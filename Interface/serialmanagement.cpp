#include "serialmanagement.h"
#include <QtSerialPort/QSerialPortInfo>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>

SerialManagement::SerialManagement(QObject *parent)
    : QObject(parent)
{
    serial = new QSerialPort(this);
    dataFile = nullptr;
    dataStream = nullptr;
    isLogging = false;
}

SerialManagement::~SerialManagement()
{
    if (isLogging) {
        closeFile();
    }
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
    qDebug() << "Intentando conectar";
    qDebug() << "Puerto actual:" << currentPort;

    if (isConnected) {
        qDebug() << "Ya estaba conectado";
        return;
    }

    serial->setPortName(currentPort);
    serial->setBaudRate(QSerialPort::Baud115200);

    if (serial->open(QIODevice::ReadWrite)) {

        isConnected = true;
        buffer.clear();
        elapsedTimer.start();
        currentFlightPhase = 0;

        qDebug() << "Conectado a" << currentPort;

        emit microcontrollerConnectionStatus(true);

        disconnect(serial, &QSerialPort::readyRead, this, nullptr);

        connect(serial, &QSerialPort::readyRead, this, &SerialManagement::onReadyRead);

    } else {
        qDebug() << "Error al abrir:" << serial->errorString();
        emit microcontrollerConnectionStatus(false);
    }
}

void SerialManagement::onReadyRead()
{
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

        // el micro envia asi: 3, Ax, Ay, Az, Gx, Gy, Gz, lat, lon, 5
        if (parts.size() >= 10 && parts.first() == "3" && parts.last() == "5") {

            float Ax = parts[1].toFloat();
            float Ay = parts[2].toFloat();
            float Az = parts[3].toFloat();

            float Gx = parts[4].toFloat();
            float Gy = parts[5].toFloat();
            float Gz = parts[6].toFloat();

            float lat = parts[7].toFloat();
            float lon = parts[8].toFloat();

            qDebug() << "DATOS OK";

            // lanzo la señal para que QML la reciba
            emit telemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon);

            float acceleration = sqrt(Ax*Ax + Ay*Ay + Az*Az);
            lastAcceleration = acceleration;

            emit accelerationUpdated(acceleration);
            
            // guardo los datos si estoy grabando
            if (isLogging && dataStream) {
                float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                *dataStream << QString("IMU,%1,%2,%3,%4,%5,%6,%7,%8,%9,%10\n")
                    .arg(elapsedSeconds, 0, 'f', 3)
                    .arg(Ax, 0, 'f', 3)
                    .arg(Ay, 0, 'f', 3)
                    .arg(Az, 0, 'f', 3)
                    .arg(Gx, 0, 'f', 3)
                    .arg(Gy, 0, 'f', 3)
                    .arg(Gz, 0, 'f', 3)
                    .arg(lat, 0, 'f', 7)
                    .arg(lon, 0, 'f', 7)
                    .arg(acceleration, 0, 'f', 3);
                dataStream->flush();
            }
            
        } else if (parts.size() >= 3 && parts.first() == "ALT") {
            // el micro manda asi: ALT, valor_altitud
            float altitude = parts[1].toFloat();
            lastAltitude = altitude;
            emit altitudeUpdated(altitude);
            qDebug() << "Altitud:" << altitude;
            
            // guardo en el archivo si estoy registrando
            if (isLogging && dataStream) {
                float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                *dataStream << QString("ALT,%1,%2\n")
                    .arg(elapsedSeconds, 0, 'f', 3)
                    .arg(altitude, 0, 'f', 3);
                dataStream->flush();
            }
            
        } else if (parts.size() >= 2 && parts.first() == "SPEED") {
            // el micro manda: SPEED, valor_velocidad
            float speed = parts[1].toFloat();
            lastSpeed = speed;
            emit speedUpdated(speed);
            qDebug() << "Velocidad:" << speed;
            
            // guardo en csv
            if (isLogging && dataStream) {
                float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                *dataStream << QString("SPEED,%1,%2\n")
                    .arg(elapsedSeconds, 0, 'f', 3)
                    .arg(speed, 0, 'f', 3);
                dataStream->flush();
            }
            
        } else if (parts.size() >= 2 && parts.first() == "VOLT") {
            // el micro manda: VOLT, valor_voltaje
            float voltage = parts[1].toFloat();
            lastVoltage = voltage;
            emit voltageUpdated(voltage);
            qDebug() << "Voltaje:" << voltage;
            
            if (isLogging && dataStream) {
                float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                *dataStream << QString("VOLT,%1,%2\n")
                    .arg(elapsedSeconds, 0, 'f', 3)
                    .arg(voltage, 0, 'f', 3);
                dataStream->flush();
            }
            
        } else if (parts.size() >= 2 && parts.first() == "TEMP") {
            // el micro manda: TEMP, valor_temperatura
            float temperature = parts[1].toFloat();
            lastTemperature = temperature;
            emit temperatureUpdated(temperature);
            qDebug() << "Temperatura:" << temperature;
            
            if (isLogging && dataStream) {
                float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                *dataStream << QString("TEMP,%1,%2\n")
                    .arg(elapsedSeconds, 0, 'f', 3)
                    .arg(temperature, 0, 'f', 1);
                dataStream->flush();
            }
            
        } else if (parts.size() >= 2 && parts.first() == "PHASE") {
            // el micro manda la fase de vuelo: PHASE, numero (0=ASCENT, 1=APOGEE, 2=MAIN_CHUTE, 3=TOUCH_DOWN)
            int phase = parts[1].toInt();
            if (phase >= 0 && phase <= 3) {
                currentFlightPhase = phase;
                emit flightPhaseUpdated(phase);
                
                if (isLogging && dataStream) {
                    float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                    *dataStream << QString("PHASE,%1,%2\n")
                        .arg(elapsedSeconds, 0, 'f', 3)
                        .arg(phase);
                    dataStream->flush();
                }
            }
            qDebug() << "Fase de vuelo:" << phase;
        }

        float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
        emit timeUpdated(elapsedSeconds);
    }
}

void SerialManagement::endConnection()
{
    if (serial->isOpen()) {
        serial->close();
        isConnected = false;
        qDebug() << "Conexión cerrada";
        emit microcontrollerConnectionStatus(false);
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

void SerialManagement::createFile()
{
    if (isLogging) {
        qDebug() << "Hay un archivo de registro abierto";
        return;
    }

    // crea el directorio si no existe
    QString dataDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/GroundStationData";
    QDir dir(dataDir);
    if (!dir.exists()) {
        dir.mkpath(dataDir);
    }

    // creo el archivo con la hora actual
    missionStartTime = QDateTime::currentDateTime();
    logFileName = QString("%1/Mission_%2.csv")
        .arg(dataDir)
        .arg(missionStartTime.toString("yyyy-MM-dd_HH-mm-ss"));

    dataFile = new QFile(logFileName);
    if (dataFile->open(QIODevice::WriteOnly | QIODevice::Text)) {
        dataStream = new QTextStream(dataFile);
        
        *dataStream << "Type,Timestamp,Value1,Value2,Value3,Value4,Value5,Value6,Value7,Value8,Value9,Value10\n";
        *dataStream << QString("MISSION_START,%1,%2,%3\n")
            .arg(missionStartTime.toString("yyyy-MM-dd HH:mm:ss"))
            .arg(currentPort)
            .arg("Cattleya Mission");
        
        isLogging = true;
        qDebug() << "Archivo de registro creado:" << logFileName;
    } else {
        qDebug() << "Error al crear archivo de registro:" << dataFile->errorString();
        delete dataFile;
        dataFile = nullptr;
    }
}

void SerialManagement::closeFile()
{
    if (!isLogging) {
        qDebug() << "No hay archivo de registro abierto";
        return;
    }

    if (dataStream) {
        QDateTime missionEndTime = QDateTime::currentDateTime();

        *dataStream << QString("MISSION_END,%1,%2\n")
            .arg(missionEndTime.toString("yyyy-MM-dd HH:mm:ss"))
            .arg("Normal completion");
        dataStream->flush();
    }

    if (dataFile) {
        dataFile->close();
        delete dataFile;
        dataFile = nullptr;
    }

    if (dataStream) {
        delete dataStream;
        dataStream = nullptr;
    }

    isLogging = false;
    qDebug() << "Archivo de registro cerrado:" << logFileName;
}

void SerialManagement::manualBoostDetected()
{
    qDebug() << "Boost manual detectado";
    currentFlightPhase = 0;
    emit flightPhaseUpdated(0);
}

void SerialManagement::manualApogeeDetected()
{
    qDebug() << "Apogeo manual detectado";
    currentFlightPhase = 1;
    emit flightPhaseUpdated(1);
    
    // Registrar evento en el archivo de log
    if (isLogging && dataStream) {
        float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
        *dataStream << QString("EVENT,%1,MANUAL_APOGEE_DETECTED\n")
            .arg(elapsedSeconds, 0, 'f', 3);
        dataStream->flush();
    }
}

void SerialManagement::manualMainDetected()
{
    qDebug() << "Main chute manual detectado";
    currentFlightPhase = 2;
    emit flightPhaseUpdated(2);
    
    if (isLogging && dataStream) {
        float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
        *dataStream << QString("EVENT,%1,MANUAL_MAIN_DETECTED\n")
            .arg(elapsedSeconds, 0, 'f', 3);
        dataStream->flush();
    }
}

void SerialManagement::manualLandingDetected()
{
    qDebug() << "Landing manual detectado";
    currentFlightPhase = 3;
    emit flightPhaseUpdated(3);

    if (isLogging && dataStream) {
        float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
        *dataStream << QString("EVENT,%1,MANUAL_LANDING_DETECTED\n")
            .arg(elapsedSeconds, 0, 'f', 3);
        dataStream->flush();
    }
}

void SerialManagement::setReferenceTime()
{
    qDebug() << "Reset de tiempo de referencia";
    elapsedTimer.restart();
    
    if (isLogging && dataStream) {
        *dataStream << QString("EVENT,%1,TIME_REFERENCE_RESET\n")
            .arg(0.000, 0, 'f', 3);
        dataStream->flush();
    }
}

void SerialManagement::sendData(QChar command)
{
    if (!isConnected || !serial->isOpen()) {
        qDebug() << "No se puede enviar comando (puerto no conectado)";
        return;
    }

    QByteArray data;
    data.append(command.toLatin1());
    serial->write(data);
    
    qDebug() << "Comando enviado:" << command;
    
    if (isLogging && dataStream) {
        float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
        *dataStream << QString("COMMAND,%1,%2\n")
            .arg(elapsedSeconds, 0, 'f', 3)
            .arg(command);
        dataStream->flush();
    }
}

void SerialManagement::sendFrequencyChange()
{
    qDebug() << "Cambiando frecuencia...";
    sendData('f');
}

