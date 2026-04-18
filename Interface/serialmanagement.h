#ifndef SERIALMANAGEMENT_H
#define SERIALMANAGEMENT_H

#include <QObject>
#include <QStringList>
#include <QSerialPort>
#include <QTimer>
#include <QDateTime>
#include <QTime>
#include <QElapsedTimer>
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <QList>

class SerialManagement : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool simulationMode READ getSimulationMode WRITE setSimulationMode)

public:
    explicit SerialManagement(QObject *parent = nullptr);
    ~SerialManagement();

    Q_INVOKABLE QStringList searchPortInfo();
    Q_INVOKABLE void savePortConnection(QString port);
    Q_INVOKABLE QString getSelectedPortDescription();
    Q_INVOKABLE void setBaudRateMode(int index);
    Q_INVOKABLE void microcontrollerConnection();
    Q_INVOKABLE void endConnection();
    Q_INVOKABLE bool getMicroConfirmation();

    Q_INVOKABLE void writeIntValue(int id, int value);
    Q_INVOKABLE void writeStringValue(int id, QString value);
    Q_INVOKABLE void changeRocketFrequency(QString value);
    Q_INVOKABLE void setEstApogeeAlt(int value);
    Q_INVOKABLE void setEstMainAlt(int value);
    Q_INVOKABLE void setEstTouchDownAlt(int value);
    
    Q_INVOKABLE void createFile();
    Q_INVOKABLE void closeFile();
    Q_INVOKABLE void manualBoostDetected();
    Q_INVOKABLE void manualApogeeDetected();
    Q_INVOKABLE void manualMainDetected();
    Q_INVOKABLE void manualLandingDetected();
    Q_INVOKABLE void setReferenceTime();
    Q_INVOKABLE void sendData(QString data);
    Q_INVOKABLE void sendFrequencyChange();

    Q_INVOKABLE float getLastDataInList(int list, int pos);
    Q_INVOKABLE float getMaxMinDataInList(int list, bool maxBool);
    Q_INVOKABLE float getAbsMaxMinDataInLists(QList<int> lists, bool maxBool);
    Q_INVOKABLE float getDataConvertedImperial(int dataWanted);
    Q_INVOKABLE QString getActualTime();
    Q_INVOKABLE int getTelemetryStatus();
    Q_INVOKABLE QString getFilePath();
    Q_INVOKABLE QString getFileName();
    Q_INVOKABLE QString getFrequency();
    Q_INVOKABLE int getEstApogeeAlt();
    Q_INVOKABLE int getEstMainAlt();
    Q_INVOKABLE int getEstTouchDownAlt();

    bool getSimulationMode() const { return simulationMode; }
    void setSimulationMode(bool mode) { simulationMode = mode; }

signals:
    void telemetryUpdated(float Ax, float Ay, float Az,
                          float Gx, float Gy, float Gz,
                          float alt, float vel, float lat,
                          float lon, float temp, float volt);
    
    void altitudeUpdated(float altitude);
    void speedUpdated(float speed);
    void accelerationUpdated(float acceleration);
    void voltageUpdated(float voltage);
    void temperatureUpdated(float temperature);
    void timeUpdated(float elapsedTime);
    void flightPhaseUpdated(int phase);
    
    void microcontrollerConnectionStatus(bool status);
    void coreDataReady();
    void logUpdate();
    void dataNotSent();
    void portNotFound();
    void portIsNotReadable();
    void portIsNotWritable();
    void portIsNotOpen();
    void cannotAcessList();
    void cannotAcessDataInList();

private slots:
    void onReadyRead();
    void simulateData();
    void coreDataUpdate();
    void writeDataFile();
    void updateMissionElapsedTime();

private:
    QSerialPort *_MCU;
    QString currentPort;
    bool isConnected = false;
    QString buffer;
    QElapsedTimer elapsedTimer;
    int currentFlightPhase = 0;
    
    bool simulationMode = false;
    QTimer *simulationTimer = nullptr;
    QTimer *missionTimer = nullptr;
    
    float lastAltitude = 0.0f;
    float lastSpeed = 0.0f;
    float lastAcceleration = 0.0f;
    float lastVoltage = 0.0f;
    float lastTemperature = 0.0f;
    float verticalSpeedEstimate = 0.0f;
    bool hasPreviousGpsFix = false;
    float previousLat = 0.0f;
    float previousLon = 0.0f;
    float previousTelemetryTime = 0.0f;
    
    QFile *dataFile = nullptr;
    QTextStream *dataStream = nullptr;
    bool isLogging = false;
    QString logFileName;
    QDateTime missionStartTime;

    QString _portDescriptionIntendedConnection;
    QString _portDescription;
    QString _portName;
    int _vendorId;
    int _productId;
    int _baudRateMode = 0;
    bool _microcontrollerFoundOnConnection = false;
    bool _microcontrollerConnected = false;
    QString _serialBuffer;
    QByteArray _serialData;
    QString completeMessage;
    QString rocketFrequency;
    int telemetryStatus = 0;
    int expectedApogeeAlt = 0;
    int expectedMainAlt = 0;
    int expectedTouchDownAlt = 0;
    float firstTimeSeconds = 0.0;
    QTime referenceTime;
    bool referencedTimeSetted = false;
    QString filePath;
    QString fileName;
    bool fileOpen2Write = false;
    bool autoDataSaveStart = false;
    bool autoDataSaveFinish = false;
    const int _maxDataMemory = 1000;

    QList<float> _accelXDataListFloat;
    QList<float> _accelYDataListFloat;
    QList<float> _accelZDataListFloat;
    QList<float> _angleXDataListFloat;
    QList<float> _angleYDataListFloat;
    QList<float> _angleZDataListFloat;
    QList<float> _currentAltDataListFloat;
    QList<float> _newerLatValueList;
    QList<float> _newerLonValueList;
    QList<float> _olderLatValueList;
    QList<float> _olderLonValueList;
    QList<float> _currentSpeedDataListFloat;
    QList<QString> _coreDataList;
    float _currentAltMinListValue = 0.0;
    float _currentAltMaxListValue = 0.0;
};

#endif // SERIALMANAGEMENT_H
