#include <QGuiApplication>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QScreen>
#include <QTextStream>

int main(int argc, char *argv[])
{
  QGuiApplication app(argc, argv);
  QJsonArray screens;

  // Preserve Qt's order: Flameshot's --number indexes this exact API.
  for (const QScreen *screen : app.screens()) {
    const QRect geometry = screen->geometry();
    screens.append(QJsonObject{
      {"x", geometry.x()},
      {"y", geometry.y()},
      {"width", geometry.width()},
      {"height", geometry.height()},
    });
  }

  QTextStream(stdout) << QJsonDocument(screens).toJson(QJsonDocument::Compact) << '\n';
}
