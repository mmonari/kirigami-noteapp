#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QUrl>
#include <QIcon>
#include <QFile>
#include <QTextStream>
#include <QProcess>
#include <QMimeDatabase>
#include <QMimeType>
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
        // Use QMimeDatabase for proper MIME type detection
        QMimeDatabase mimeDb;
        QMimeType mimeType = mimeDb.mimeTypeForFile(filePath);
        QString mimeTypeName = mimeType.name();
        
        qDebug() << "MIME type for" << filePath << ":" << mimeTypeName;
        
        // Check if it's a text-based MIME type
        // This covers text/plain and all its derivatives
        if (mimeTypeName.startsWith("text/")) {
            return true;
        }
        
        // Additional application MIME types that are text-based
        QStringList textBasedMimeTypes = {
            "application/json",
            "application/x-yaml",
            "application/yaml",
            "application/xml",
            "application/x-docbook+xml",
            "application/xhtml+xml",
            "application/javascript",
            "application/x-shellscript",
            "application/x-perl",
            "application/x-python",
            "application/x-ruby",
            "application/x-php",
            "application/x-desktop",
            "application/x-config",
            "application/toml",
            "application/x-wine-extension-ini"
        };
        
        if (textBasedMimeTypes.contains(mimeTypeName)) {
            return true;
        }
        
        // Check if the MIME type inherits from text/plain
        if (mimeType.inherits("text/plain")) {
            return true;
        }
        
        // Fallback: check if MIME type name contains "text" or if it's empty (unknown)
        // This helps with edge cases
        if (mimeTypeName.contains("text", Qt::CaseInsensitive)) {
            return true;
        }
        
        return false;
    }
    
    Q_INVOKABLE QString getMimeType(const QString &filePath) {
        // Utility function to get MIME type for display/debugging
        QMimeDatabase mimeDb;
        QMimeType mimeType = mimeDb.mimeTypeForFile(filePath);
        return mimeType.name();
    }
    
    Q_INVOKABLE QString getMimeTypeComment(const QString &filePath) {
        // Get human-readable MIME type description
        QMimeDatabase mimeDb;
        QMimeType mimeType = mimeDb.mimeTypeForFile(filePath);
        return mimeType.comment();
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
