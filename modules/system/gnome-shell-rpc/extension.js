// D-Bus entry point for the scripts declared in `gnome-shell-rpc.scripts`.
//
// Only plumbing lives here. gnome-shell imports extension.js exactly once per
// session -- "Extensions can only be imported once", extensionSystem.js -- and
// neither toggling the extension nor the deprecated ReloadExtension re-reads
// it, so whatever is embedded here needs a new session to change. Scripts are
// therefore sibling modules imported on demand: GJS keys its module registry by
// full URI, so a `?v=` carrying a hash of the scripts hands back a fresh module
// whenever they change. Editing a script needs a rebuild, editing this file
// still needs a logout.
//
// The D-Bus identifiers are substituted by module.nix.

import Gio from "gi://Gio";
import GLib from "gi://GLib";
import { Extension } from "resource:///org/gnome/shell/extensions/extension.js";

const INTERFACE_NAME = "@interface@";
const OBJECT_PATH = "@objectPath@";

const INTERFACE_XML = `
<node>
  <interface name="${INTERFACE_NAME}">
    <method name="Run">
      <arg type="s" direction="in" name="name"/>
      <arg type="s" direction="in" name="args"/>
      <arg type="s" direction="out" name="result"/>
    </method>
    <method name="List">
      <arg type="s" direction="out" name="scripts"/>
    </method>
  </interface>
</node>`;

// Belt and braces next to the index lookup: whatever reaches the file name must
// not be able to climb out of the scripts directory.
const SCRIPT_NAME = /^[a-z0-9][a-z0-9-]*$/;

// `String(error)` carries the type and message, the stack carries the location,
// and neither is reliably present: GJS throws ImportError -- what a syntax error
// in a script looks like from here -- with an empty stack.
const describe = (error) =>
  [String(error), error?.stack].filter(Boolean).join("\n");

export default class GnomeShellRpcExtension extends Extension {
  enable() {
    this._dbus = Gio.DBusExportedObject.wrapJSObject(INTERFACE_XML, this);
    this._dbus.export(Gio.DBus.session, OBJECT_PATH);
  }

  disable() {
    this._dbus?.unexport();
    this._dbus = null;
  }

  /**
   * @returns {Gio.File} the generated scripts directory
   */
  _scriptsDir() {
    return this.dir.get_child("scripts");
  }

  /**
   * Read the generated script index. Done per call so that adding, removing
   * or re-describing a script also takes effect without a new session.
   *
   * @returns {{version: string, scripts: Object<string, string>}} the index
   */
  _readIndex() {
    const [, contents] = this._scriptsDir()
      .get_child("index.json")
      .load_contents(null);

    return JSON.parse(new TextDecoder().decode(contents));
  }

  _returnError(invocation, message, code = Gio.DBusError.FAILED) {
    invocation.return_error_literal(Gio.DBusError, code, message);
  }

  ListAsync(_params, invocation) {
    try {
      const { scripts } = this._readIndex();

      invocation.return_value(
        new GLib.Variant("(s)", [JSON.stringify(scripts)]),
      );
    } catch (error) {
      this._returnError(invocation, describe(error));
    }
  }

  async RunAsync([name, args], invocation) {
    let index;

    try {
      index = this._readIndex();
    } catch (error) {
      this._returnError(invocation, describe(error));
      return;
    }

    if (!SCRIPT_NAME.test(name) || !Object.hasOwn(index.scripts, name)) {
      this._returnError(
        invocation,
        `Unknown script: ${name}`,
        Gio.DBusError.INVALID_ARGS,
      );
      return;
    }

    let parsedArgs;

    try {
      parsedArgs = args === "" ? {} : JSON.parse(args);
    } catch (error) {
      this._returnError(
        invocation,
        `Invalid JSON arguments: ${describe(error)}`,
        Gio.DBusError.INVALID_ARGS,
      );
      return;
    }

    if (
      parsedArgs === null ||
      Array.isArray(parsedArgs) ||
      typeof parsedArgs !== "object"
    ) {
      this._returnError(
        invocation,
        "Arguments must be a JSON object",
        Gio.DBusError.INVALID_ARGS,
      );
      return;
    }

    try {
      const file = this._scriptsDir().get_child(`${name}.js`);
      const module = await import(`${file.get_uri()}?v=${index.version}`);
      const result = await module.default(parsedArgs);

      // D-Bus has no null, so undefined and null both go over as JSON
      // `null` and the client drops them.
      invocation.return_value(
        new GLib.Variant("(s)", [JSON.stringify(result ?? null)]),
      );
    } catch (error) {
      this._returnError(invocation, `${name}: ${describe(error)}`);
    }
  }
}
