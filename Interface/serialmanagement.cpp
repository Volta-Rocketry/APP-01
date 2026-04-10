#include "serialmanagement.h"
#include <QtSerialPort/QSerialPortInfo>
#include <QDebug>

SerialManagement::SerialManagement(QObject *parent)
    : QObject(parent)
{
    serial = new QSerialPort(this);
}

QStringList SerialManagement::searchPortInfo()
{
    QStringList ports;

    qDebug() << "Buscando puertos...";

    const auto availablePorts = QSerialPortInfo::availablePorts();

    for (const QSerialPortInfo &port : availablePorts) {
        ports.append(port.portName());
        qDebug() << "Puerto encontrado:" << port.portName();
    }

    return ports;
}

void SerialManagement::savePortConnection(QString port)
{
    currentPort = port;
    qDebug() << "Puerto guardado:" << port;
}

void SerialManagement::setBaudRateMode(int index)
{
    qDebug() << "BaudRate index:" << index;
}

void SerialManagement::microcontrollerConnection()
{
    qDebug() << "INTENTANDO CONECTAR";
    qDebug() << "Puerto actual:" << currentPort;

    if (isConnected) {
        qDebug() << "YA ESTABA CONECTADO";
        return;
    }

    serial->setPortName(currentPort);
    serial->setBaudRate(QSerialPort::Baud115200); // ⚠️ importante

    if (serial->open(QIODevice::ReadWrite)) {

        isConnected = true;
        buffer.clear();

        qDebug() << "Conectado a" << currentPort;

        connect(serial, &QSerialPort::readyRead, this, [=]() {

            buffer += serial->readAll();

            while (buffer.contains('\n')) {

                int index = buffer.indexOf('\n');
                QString line = buffer.left(index).trimmed();
                buffer.remove(0, index + 1);

                qDebug() << "LINEA COMPLETA:" << line;

                QStringList parts = line.split(",", Qt::SkipEmptyParts);

                for (int i = 0; i < parts.size(); i++) {
                    parts[i] = parts[i].trimmed();
                }

                qDebug() << "PARTES:" << parts;

                if (parts.size() == 10 && parts.first() == "3" && parts.last() == "5") {

                    float Ax = parts[1].toFloat();
                    float Ay = parts[2].toFloat();
                    float Az = parts[3].toFloat();

                    float Gx = parts[4].toFloat();
                    float Gy = parts[5].toFloat();
                    float Gz = parts[6].toFloat();

                    float lat = parts[7].toFloat();
                    float lon = parts[8].toFloat();

                    qDebug() << "DATOS OK";

                    emit telemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon);

                } else {
                    qDebug() << "Paquete inválido";
                }
            }
        });

    } else {
        qDebug() << "ERROR AL ABRIR:" << serial->errorString();
    }
}

void SerialManagement::endConnection()
{
    if (serial->isOpen()) {
        serial->close();
        isConnected = false;
        qDebug() << "Conexión cerrada";
    }
}

bool SerialManagement::getMicroConfirmation()
{
    return isConnected;
}

void SerialManagement::writeIntValue(int id, int value)
{
    qDebug() << "writeIntValue:" << id << value;
}

void SerialManagement::writeStringValue(int id, QString value)
{
    qDebug() << "writeStringValue:" << id << value;
}

void SerialManagement::changeRocketFrequency(QString value)
{
    qDebug() << "Frecuencia:" << value;
}


