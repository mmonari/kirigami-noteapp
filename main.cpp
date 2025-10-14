#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <QIcon>
#include <QFile>
#include <QTextStream>
#include <KLocalizedContext>
#include <KLocalizedString>

// Simple file I/O class for QML
class FileIO : public QObject
{
    Q_OBJECT
    
public:
    explicit FileIO(QObject *parent = nullptr) : QObject(parent) {}
    
    Q_INVOKABLE QString read(const QString &filePath) {
        QFile file(filePath);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning() << "Could not open file for reading:" << filePath;
            return QString();
        }
        
        QTextStream in(&file);
        QString content = in.readAll();
        file.close();
        return content;
    }
    
    Q_INVOKABLE bool write(const QString &filePath, const QString &content) {
        QFile file(filePath);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
            qWarning() << "Could not open file for writing:" << filePath;
            return false;
        }
        
        QTextStream out(&file);
        out << content;
        file.close();
        return true;
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // Set application metadata
    QApplication::setApplicationName(QStringLiteral("Kirigami NoteApp"));
    QApplication::setOrganizationName(QStringLiteral("KDE"));
    QApplication::setApplicationVersion(QStringLiteral("1.0"));
    QApplication::setWindowIcon(QIcon::fromTheme(QStringLiteral("text-editor")));
    
    // Set translation domain
    KLocalizedString::setApplicationDomain("kirigami-notepad");
    
    // Create QML engine
    QQmlApplicationEngine engine;
    
    // Enable localization in QML
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    
    // Expose FileIO to QML
    FileIO fileIO;
    engine.rootContext()->setContextProperty("fileIO", &fileIO);
    
    // Load main QML file from current directory
    const QUrl url(QUrl::fromLocalFile(QStringLiteral("main.qml")));
    engine.load(url);
    
    if (engine.rootObjects().isEmpty()) {
        qWarning() << "Failed to load QML file";
        return -1;
    }
    
    return app.exec();
}

#include "main.moc"
