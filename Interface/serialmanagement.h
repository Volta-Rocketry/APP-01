#ifndef SERIALMANAGEMENT_H
#define SERIALMANAGEMENT_H

#include <QObject>
#include <QStringList>
#include <QSerialPort>
#include <QDateTime>
#include <QElapsedTimer>
#include <QFile>
#include <QTextStream>
#include <QDir>

class SerialManagement : public QObject
{
    Q_OBJECT

public:
    explicit SerialManagement(QObject *parent = nullptr);
    ~SerialManagement();

    Q_INVOKABLE QStringList searchPortInfo();
    Q_INVOKABLE void savePortConnection(QString port);
    Q_INVOKABLE void setBaudRateMode(int index);
    Q_INVOKABLE void microcontrollerConnection();
    Q_INVOKABLE void endConnection();
    Q_INVOKABLE bool getMicroConfirmation();

    Q_INVOKABLE void writeIntValue(int id, int value);
    Q_INVOKABLE void writeStringValue(int id, QString value);
    Q_INVOKABLE void changeRocketFrequency(QString value);
    
    Q_INVOKABLE void createFile();
    Q_INVOKABLE void closeFile();
    Q_INVOKABLE void manualBoostDetected();
    Q_INVOKABLE void manualApogeeDetected();
    Q_INVOKABLE void manualMainDetected();
    Q_INVOKABLE void manualLandingDetected();
    Q_INVOKABLE void setReferenceTime();
    Q_INVOKABLE void sendData(QChar command);
    Q_INVOKABLE void sendFrequencyChange();

signals:
    void telemetryUpdated(float Ax, float Ay, float Az,
                          float Gx, float Gy, float Gz,
                          float lat, float lon);
    
    void altitudeUpdated(float altitude);
    void speedUpdated(float speed);
    void accelerationUpdated(float acceleration);
    void voltageUpdated(float voltage);
    void temperatureUpdated(float temperature);
    void timeUpdated(float elapsedTime);
    void flightPhaseUpdated(int phase);
    
    void microcontrollerConnectionStatus(bool status);

private slots:
    void onReadyRead();

private:
    QSerialPort *serial;
    QString currentPort;
    bool isConnected = false;
    QString buffer;
    QElapsedTimer elapsedTimer;
    int currentFlightPhase = 0;
    
    float lastAltitude = 0.0f;
    float lastSpeed = 0.0f;
    float lastAcceleration = 0.0f;
    float lastVoltage = 0.0f;
    float lastTemperature = 0.0f;
    
    QFile *dataFile = nullptr;
    QTextStream *dataStream = nullptr;
    bool isLogging = false;
    QString logFileName;
    QDateTime missionStartTime;
};

#endif // SERIALMANAGEMENT_H
