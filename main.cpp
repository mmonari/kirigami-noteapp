#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <QIcon>
#include <QFile>
#include <QTextStream>
#include <QProcess>
#include <KLocalizedContext>
#include <KLocalizedString>

// Simple file I/O class for QML
class FileIO : public QObject
{
    Q_OBJECT
    
public:
    explicit FileIO(QObject *parent = nullptr) : QObject(parent) {}
    
    Q_INVOKABLE QString read(const QString &filePath) {
        qDebug() << "Attempting to read file:" << filePath;
        QFile file(filePath);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qWarning() << "Could not open file for reading:" << filePath;
            qWarning() << "File exists:" << file.exists();
            return QString();
        }
        
        QTextStream in(&file);
        QString content = in.readAll();
        file.close();
        qDebug() << "Successfully read" << content.length() << "characters from:" << filePath;
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
    
    Q_INVOKABLE bool isTextFile(const QString &filePath) {
        // Simple text file detection based on extension
        QString lower = filePath.toLower();
        return lower.endsWith(".txt") || 
               lower.endsWith(".md") || 
               lower.endsWith(".log") ||
               lower.endsWith(".conf") ||
               lower.endsWith(".cfg") ||
               lower.endsWith(".ini") ||
               lower.endsWith(".xml") ||
               lower.endsWith(".json") ||
               lower.endsWith(".qml") ||
               lower.endsWith(".cpp") ||
               lower.endsWith(".h") ||
               lower.endsWith(".py") ||
               lower.endsWith(".js");
    }
    
    Q_INVOKABLE void openInNewInstance(const QString &filePath) {
        QStringList args;
        args << filePath;
        bool success = QProcess::startDetached(QCoreApplication::applicationFilePath(), args);
        if (!success) {
            qWarning() << "Failed to start new instance with file:" << filePath;
        } else {
            qDebug() << "Starting new instance with file:" << filePath;
        }
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
    KLocalizedString::setApplicationDomain("kirigami-noteapp");
    
    // Create QML engine
    QQmlApplicationEngine engine;
    
    // Enable localization in QML
    engine.rootContext()->setContextObject(new KLocalizedContext(&engine));
    
    // Expose FileIO to QML
    FileIO fileIO;
    engine.rootContext()->setContextProperty("fileIO", &fileIO);
    
    // Check for file argument from command line
    QString initialFile;
    if (argc > 1) {
        initialFile = QString::fromLocal8Bit(argv[1]);
        qDebug() << "Received file argument:" << initialFile;
    } else {
        qDebug() << "No file argument provided";
    }
    engine.rootContext()->setContextProperty("initialFile", initialFile);
    
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
