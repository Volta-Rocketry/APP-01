#ifndef SERIALMANAGEMENT_H
#define SERIALMANAGEMENT_H

#include <QObject>
#include <QStringList>
#include <QSerialPort>

class SerialManagement : public QObject
{
    Q_OBJECT

public:
    explicit SerialManagement(QObject *parent = nullptr);

    Q_INVOKABLE QStringList searchPortInfo();
    Q_INVOKABLE void savePortConnection(QString port);
    Q_INVOKABLE void setBaudRateMode(int index);
    Q_INVOKABLE void microcontrollerConnection();
    Q_INVOKABLE void endConnection();
    Q_INVOKABLE bool getMicroConfirmation();

    Q_INVOKABLE void writeIntValue(int id, int value);
    Q_INVOKABLE void writeStringValue(int id, QString value);
    Q_INVOKABLE void changeRocketFrequency(QString value);

signals:
    void telemetryUpdated(float Ax, float Ay, float Az,
                          float Gx, float Gy, float Gz,
                          float lat, float lon);

private:
    QSerialPort *serial;
    QString currentPort;
    bool isConnected = false;
    QString buffer;
};

#endif // SERIALMANAGEMENT_H
