#include "serialmanagement.h"
#include <QtSerialPort/QSerialPortInfo>
#include <QDebug>
#include <QStandardPaths>
#include <QDir>
#include <QUrl>
#include <QTime>
#include <QRegularExpression>
#include <QtMath>
#include <cmath>
#include <cstdlib>

SerialManagement::SerialManagement(QObject *parent)
    : QObject(parent)
{
    _MCU = new QSerialPort(this);
    simulationTimer = new QTimer(this);
    connect(simulationTimer, &QTimer::timeout, this, &SerialManagement::simulateData);
    dataFile = nullptr;
    dataStream = nullptr;
    isLogging = false;

    // Initialize new variables from provided code
    _microcontrollerFoundOnConnection = false;
    _microcontrollerConnected = false;
    _serialBuffer = "";

    QDateTime dateTime = QDateTime::currentDateTimeUtc();
    qint64 timestamp = QDateTime::currentMSecsSinceEpoch();

    int minutes = dateTime.time().minute();
    int seconds = dateTime.time().second();
    int milliseconds = timestamp % 1000;

    // Convertir a segundos como número real
    firstTimeSeconds = minutes * 60 + seconds + milliseconds / 1000.0;
}

SerialManagement::~SerialManagement()
{
    if (isLogging) {
        closeFile();
    }
    if (_MCU) {
        delete _MCU;
    }
}

QStringList SerialManagement::searchPortInfo()
{
    QStringList availableSerialNames;
    QStringList availableSerialPorts;

    foreach (const QSerialPortInfo &port, QSerialPortInfo::availablePorts()) {
        if (port.description() != ""){
            availableSerialNames.append(port.description());
            availableSerialPorts.append(port.portName());
        }
    }

    qDebug() << availableSerialNames;
    qDebug() << availableSerialPorts;

    return availableSerialNames;
}

void SerialManagement::savePortConnection(QString portDescription)
{
    _portDescriptionIntendedConnection = portDescription;
}

void SerialManagement::setBaudRateMode(int mode)
{
    /* Modes
     * 0 -> 115200
     * 1 -> 9600
     * 2 -> 1200
     * 3 -> 2400
     * 4 -> 4800
     * 5 -> 19200
     * 6 -> 38400
     * 7 -> 57600
    */

    _baudRateMode = mode;
}

void SerialManagement::microcontrollerConnection()
{
    if (_portDescriptionIntendedConnection == "Test Mode"){
        // Assuming test mode is simulation
        simulationMode = true;
        _microcontrollerConnected = true;
        isConnected = true;
        buffer.clear();
        elapsedTimer.restart();
        currentFlightPhase = 0;
        simulationTimer->start(100);  // Simular cada 100ms
        qDebug() << "Modo simulación activado";
        emit microcontrollerConnectionStatus(true);
        return;
    }else{

        qDebug() << "Entro CCC";

        if (QSerialPortInfo::availablePorts().size() > 0){
            bool foundPort = false;
            foreach (const QSerialPortInfo &serial_info, QSerialPortInfo::availablePorts()) { // Find each microcontroller available for connection
                if (serial_info.description() == _portDescriptionIntendedConnection) {    // If it detects the microcontroller selected by the user, it gets the data
                    foundPort = true;
                    // Update important port parameters
                    _portDescription = _portDescriptionIntendedConnection;
                    _portName = serial_info.portName();
                    _vendorId = serial_info.vendorIdentifier();
                    _productId = serial_info.productIdentifier();

                    _microcontrollerFoundOnConnection = true;

                    qDebug() << "Nombre: " << _portDescription;
                    qDebug() << "Puerto: " << _portName;
                    qDebug() << "Vendor ID: " << _vendorId;
                    qDebug() << "Product ID: " << _productId ;

                    // Start connection
                    _MCU->setPortName(_portName);

                    /* Modes
                     * 0 -> 115200
                     * 1 -> 9600
                     * 2 -> 1200
                     * 3 -> 2400
                     * 4 -> 4800
                     * 5 -> 19200
                     * 6 -> 38400
                     * 7 -> 57600
                    */

                    switch (_baudRateMode){
                    case 0:
                        _MCU->setBaudRate(QSerialPort::Baud115200);
                        break;
                    case 1:
                        _MCU->setBaudRate(QSerialPort::Baud9600);
                        break;
                    case 2:
                        _MCU->setBaudRate(QSerialPort::Baud1200);
                        break;
                    case 3:
                        _MCU->setBaudRate(QSerialPort::Baud2400);
                        break;
                    case 4:
                        _MCU->setBaudRate(QSerialPort::Baud4800);
                        break;
                    case 5:
                        _MCU->setBaudRate(QSerialPort::Baud19200);
                        break;
                    case 6:
                        _MCU->setBaudRate(QSerialPort::Baud38400);
                        break;
                    case 7:
                        _MCU->setBaudRate(QSerialPort::Baud57600);
                        break;
                    }

                    qDebug() << _baudRateMode;

                    _MCU->setDataBits(QSerialPort::Data8);
                    _MCU->setParity(QSerialPort::NoParity);
                    _MCU->setStopBits(QSerialPort::OneStop);
                    _MCU->setFlowControl(QSerialPort::NoFlowControl);
                    _MCU->setReadBufferSize(16384);
                    //Confirm connection
                    _MCU->open(QIODevice::ReadWrite);

                    if (_MCU->isOpen()) {
                        if(_MCU->isReadable()){
                            if(_MCU->isWritable()){
                                _microcontrollerConnected = true;
                                isConnected = true;
                                elapsedTimer.restart();
                                referencedTimeSetted = true;
                                hasPreviousGpsFix = false;
                                previousTelemetryTime = 0.0f;
                                verticalSpeedEstimate = 0.0f;
                                emit microcontrollerConnectionStatus(_microcontrollerConnected);
                                qDebug() << "CONEXIÓN SUPER EXTIOSA";
                                connect(_MCU, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
                            }else{
                                _microcontrollerConnected = false;
                                emit portIsNotWritable();
                            }
                        }else{
                            _microcontrollerConnected = false;
                            emit portIsNotReadable();
                        }
                    }else{
                        _microcontrollerConnected = false;
                        emit portIsNotOpen();
                    }
                    break;
                }
            }
            if (!foundPort) {
                _microcontrollerFoundOnConnection = false;
                emit portNotFound();
            }
        }else{
            _microcontrollerFoundOnConnection = false;  // If it does not find the microcontroller selected by the user
            emit portNotFound();
        }
    }
}

void SerialManagement::onReadyRead()
{
    if (!_MCU->isReadable()) {
        return;
    }    

    // Read all available data    
    _serialData = _MCU->readAll();
    _serialBuffer += QString::fromUtf8(_serialData);

    // Process complete messages
    while (_serialBuffer.contains("\r\n")) {
        // Extract the first complete message
        int endIndex = _serialBuffer.indexOf("\r\n");
        completeMessage = _serialBuffer.left(endIndex);
        _serialBuffer = _serialBuffer.mid(endIndex + 2); // Remove the processed message from the buffer
        emit logUpdate();
        qDebug() << "This is the complete message extracted: " << completeMessage;
        qDebug() << "Serial buffer remaining:" << _serialBuffer;

        if (completeMessage.size() > 2) {
            int cat = -1;
            QString payload;

            // Accept both "N:..." and "N,..." packet prefixes.
            if (completeMessage[1] == ':' || completeMessage[1] == ',') {
                cat = QString(completeMessage[0]).toInt();
                payload = completeMessage.mid(2).trimmed();
            } else {
                int splitIdx = completeMessage.indexOf(QRegularExpression("[:,]"));
                if (splitIdx > 0) {
                    cat = completeMessage.left(splitIdx).toInt();
                    payload = completeMessage.mid(splitIdx + 1).trimmed();
                }
            }

            if (cat < 0 || payload.isEmpty()) {
                qDebug() << "Malformed serial packet:" << completeMessage;
                continue;
            }

            QList<QString> data = payload.split(",", Qt::SkipEmptyParts);

            qDebug() << "Data Splitted: " << data;

            if (cat == 0){
                _coreDataList = data;
                qDebug()<<"Data for update Core";
                coreDataUpdate();

            }else if (cat == 1){
                // Handle other categories if needed
            }else if(cat == 2){
                if (!data.isEmpty()) {
                    telemetryStatus = data.first().toInt();
                }
                //telemetryStatusUpdate();
            }else if(cat == 3){
                // IMU + GPS packet: Ax,Ay,Az,Gx,Gy,Gz,Lat,Lon[,status]
                if (data.length() >= 8) {
                    float Ax = data[0].toFloat();
                    float Ay = data[1].toFloat();
                    float Az = data[2].toFloat();
                    float Gx = data[3].toFloat();
                    float Gy = data[4].toFloat();
                    float Gz = data[5].toFloat();
                    float lat = data[6].toFloat();
                    float lon = data[7].toFloat();

                    _accelXDataListFloat.append(Ax);
                    _accelYDataListFloat.append(Ay);
                    _accelZDataListFloat.append(Az);
                    _angleXDataListFloat.append(Gx);
                    _angleYDataListFloat.append(Gy);
                    _angleZDataListFloat.append(Gz);
                    _newerLatValueList.append(lat);
                    _newerLonValueList.append(lon);

                    if (_accelXDataListFloat.count() > _maxDataMemory) _accelXDataListFloat.removeFirst();
                    if (_accelYDataListFloat.count() > _maxDataMemory) _accelYDataListFloat.removeFirst();
                    if (_accelZDataListFloat.count() > _maxDataMemory) _accelZDataListFloat.removeFirst();
                    if (_angleXDataListFloat.count() > _maxDataMemory) _angleXDataListFloat.removeFirst();
                    if (_angleYDataListFloat.count() > _maxDataMemory) _angleYDataListFloat.removeFirst();
                    if (_angleZDataListFloat.count() > _maxDataMemory) _angleZDataListFloat.removeFirst();
                    if (_newerLatValueList.count() > _maxDataMemory) _newerLatValueList.removeFirst();
                    if (_newerLonValueList.count() > _maxDataMemory) _newerLonValueList.removeFirst();

                    lastAcceleration = std::sqrt(Ax*Ax + Ay*Ay + Az*Az);
                    emit telemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon);
                    emit accelerationUpdated(lastAcceleration);

                    if (!elapsedTimer.isValid()) {
                        elapsedTimer.start();
                    }

                    float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
                    emit timeUpdated(elapsedSeconds);

                    // Fallback for missions that only stream IMU+GPS packets.
                    if (hasPreviousGpsFix) {
                        float dt = elapsedSeconds - previousTelemetryTime;
                        if (dt > 0.01f) {
                            constexpr float earthRadiusMeters = 6371000.0f;
                            const float lat1 = qDegreesToRadians(previousLat);
                            const float lat2 = qDegreesToRadians(lat);
                            const float dLat = lat2 - lat1;
                            const float dLon = qDegreesToRadians(lon - previousLon);
                            const float a = qSin(dLat / 2.0f) * qSin(dLat / 2.0f)
                                            + qCos(lat1) * qCos(lat2)
                                            * qSin(dLon / 2.0f) * qSin(dLon / 2.0f);
                            const float c = 2.0f * qAtan2(qSqrt(a), qSqrt(1.0f - a));
                            const float distanceMeters = earthRadiusMeters * c;

                            const float gpsSpeed = qBound(0.0f, distanceMeters / dt, 600.0f);
                            lastSpeed = 0.65f * lastSpeed + 0.35f * gpsSpeed;

                            const float verticalAcceleration = Az - 9.80665f;
                            verticalSpeedEstimate = (verticalSpeedEstimate + verticalAcceleration * dt) * 0.98f;
                            lastAltitude = qMax(0.0f, lastAltitude + verticalSpeedEstimate * dt);
                        }
                    }

                    emit speedUpdated(lastSpeed);
                    emit altitudeUpdated(lastAltitude);

                    previousLat = lat;
                    previousLon = lon;
                    previousTelemetryTime = elapsedSeconds;
                    hasPreviousGpsFix = true;

                    if (data.length() >= 9) {
                        telemetryStatus = data[8].toInt();
                    }

                    int flightPhase = 0;
                    if (telemetryStatus >= 6) {
                        flightPhase = 3;
                    } else if (telemetryStatus >= 3) {
                        flightPhase = 2;
                    } else if (telemetryStatus >= 2) {
                        flightPhase = 1;
                    }
                    emit flightPhaseUpdated(flightPhase);

                    // Optional extra values after status: voltage and temperature.
                    if (data.length() >= 11) {
                        lastVoltage = data[9].toFloat();
                        lastTemperature = data[10].toFloat();
                        emit voltageUpdated(lastVoltage);
                        emit temperatureUpdated(lastTemperature);
                    }
                }
            }else if(cat == 4){
                // Auxiliary packet for electrical/environmental data.
                if (data.length() >= 1) {
                    lastVoltage = data[0].toFloat();
                    emit voltageUpdated(lastVoltage);
                }
                if (data.length() >= 2) {
                    lastTemperature = data[1].toFloat();
                    emit temperatureUpdated(lastTemperature);
                }
            }else if(cat == 6){
                // Auxiliary packet for altitude/speed if firmware sends split telemetry.
                if (data.length() >= 1) {
                    lastAltitude = data[0].toFloat();
                    emit altitudeUpdated(lastAltitude);
                }
                if (data.length() >= 2) {
                    lastSpeed = data[1].toFloat();
                    emit speedUpdated(lastSpeed);
                }
            }
        }
    }
}

void SerialManagement::coreDataUpdate()
{
    if (_coreDataList.length() < 12)
    {
        qDebug() << "Lista con elementos faltantes";
        return;
    }
    /* _coreDataList
     *  0               1   2   3    4    5    6    7   8               9   10   11
     *  cycleNumber     Ax  Ay  Az  Anx  Any  Anz  Alt  currentStage    Vel Lat Lon
    */
    qDebug() << "LISTA ES: " << _coreDataList;

    // Accel
    _accelXDataListFloat.append(_coreDataList[1].toFloat());
    _accelYDataListFloat.append(_coreDataList[2].toFloat());
    _accelZDataListFloat.append(_coreDataList[3].toFloat());

    if (_accelXDataListFloat.count() > _maxDataMemory){
        _accelXDataListFloat.removeFirst();
    }
    if (_accelYDataListFloat.count() > _maxDataMemory){
        _accelYDataListFloat.removeFirst();
    }
    if (_accelZDataListFloat.count() > _maxDataMemory){
        _accelZDataListFloat.removeFirst();
    }

    // Angles
    _angleXDataListFloat.append(_coreDataList[4].toFloat());
    _angleYDataListFloat.append(_coreDataList[5].toFloat());
    _angleZDataListFloat.append(_coreDataList[6].toFloat());

    if (_angleXDataListFloat.count() > _maxDataMemory){
        _angleXDataListFloat.removeFirst();
    }
    if (_angleYDataListFloat.count() > _maxDataMemory){
        _angleYDataListFloat.removeFirst();
    }
    if (_angleZDataListFloat.count() > _maxDataMemory){
        _angleZDataListFloat.removeFirst();
    }

    // Altitude
    _currentAltDataListFloat.append(_coreDataList[7].toFloat());

    if (_currentAltDataListFloat.count() > _maxDataMemory){
        _currentAltDataListFloat.removeFirst();
    }

    auto min = std::min_element(_currentAltDataListFloat.begin(), _currentAltDataListFloat.end());
    auto max = std::max_element(_currentAltDataListFloat.begin(), _currentAltDataListFloat.end());

    _currentAltMinListValue = *min;
    _currentAltMaxListValue = *max;

    // GPS
    _newerLatValueList.append(_coreDataList[10].toFloat());
    if (_newerLatValueList.count()>_maxDataMemory/2){
        _olderLatValueList.append(_newerLatValueList[0]);
        _newerLatValueList.removeFirst();
        if(_olderLatValueList.count()>_maxDataMemory/2){
            _olderLatValueList.removeFirst();
        }
    }

    _newerLonValueList.append(_coreDataList[11].toFloat());
    if (_newerLonValueList.count()>_maxDataMemory/2){
        _olderLonValueList.append(_newerLonValueList[0]);
        _newerLonValueList.removeFirst();
        if(_olderLonValueList.count()>_maxDataMemory/2){
            _olderLonValueList.removeFirst();
        }
    }

    // Speed
    _currentSpeedDataListFloat.append(_coreDataList[9].toFloat());

    if (_currentSpeedDataListFloat.count() > _maxDataMemory){
        _currentSpeedDataListFloat.removeFirst();
    }

    // Status
    telemetryStatus = _coreDataList[8].toInt();
    //qDebug() << "Status " << telemetryStatus;

    // Emit updates for the QML UI.
    float elapsedSeconds = _coreDataList[0].toFloat();
    float Ax = _coreDataList[1].toFloat();
    float Ay = _coreDataList[2].toFloat();
    float Az = _coreDataList[3].toFloat();
    float Gx = _coreDataList[4].toFloat();
    float Gy = _coreDataList[5].toFloat();
    float Gz = _coreDataList[6].toFloat();
    lastAltitude = _coreDataList[7].toFloat();
    lastSpeed = _coreDataList[9].toFloat();
    float lat = _coreDataList[10].toFloat();
    float lon = _coreDataList[11].toFloat();
    lastAcceleration = std::sqrt(Ax*Ax + Ay*Ay + Az*Az);

    emit timeUpdated(elapsedSeconds);
    emit altitudeUpdated(lastAltitude);
    emit speedUpdated(lastSpeed);
    emit accelerationUpdated(lastAcceleration);
    emit telemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon);

    int flightPhase = 0;
    if (telemetryStatus >= 6) {
        flightPhase = 3;
    } else if (telemetryStatus >= 3) {
        flightPhase = 2;
    } else if (telemetryStatus >= 2) {
        flightPhase = 1;
    }
    emit flightPhaseUpdated(flightPhase);

    if (!referencedTimeSetted && telemetryStatus==1){
        setReferenceTime();
        referencedTimeSetted = true;
    }

    if(telemetryStatus==1 && autoDataSaveStart && !isLogging){
        createFile();
    }

    if(telemetryStatus==6 && autoDataSaveFinish && isLogging){
        closeFile();
    }

    qDebug() << "CoreDataUpdated";
    writeDataFile();
    emit coreDataReady();
}

void SerialManagement::simulateData()
{
    float elapsedSeconds = elapsedTimer.elapsed() / 1000.0f;
    emit timeUpdated(elapsedSeconds);

    // Simular telemetría IMU
    float Ax = (rand() % 2000 - 1000) / 100.0f;
    float Ay = (rand() % 2000 - 1000) / 100.0f;
    float Az = 9.8f + (rand() % 200 - 100) / 100.0f;
    float Gx = (rand() % 1000 - 500) / 10.0f;
    float Gy = (rand() % 1000 - 500) / 10.0f;
    float Gz = (rand() % 1000 - 500) / 10.0f;
    float Anx = Ax * 0.1f;
    float Any = Ay * 0.1f;
    float Anz = Az * 0.1f;
    float lat = 40.7128f + (rand() % 1000 - 500) / 10000.0f;
    float lon = -74.0060f + (rand() % 1000 - 500) / 10000.0f;

    if (elapsedSeconds < 30) {
        lastAltitude += 2.0f;
    } else if (elapsedSeconds < 60) {
        lastAltitude -= 1.0f;
    }
    if (lastAltitude < 0) {
        lastAltitude = 0.0f;
    }
    emit altitudeUpdated(lastAltitude);

    lastSpeed = qMax(0.0f, lastAltitude > 0 ? 2.0f : 0.0f);
    emit speedUpdated(lastSpeed);

    lastAcceleration = std::sqrt(Ax*Ax + Ay*Ay + Az*Az);
    emit accelerationUpdated(lastAcceleration);

    lastVoltage = 3.7f + (rand() % 30 - 15) / 100.0f;
    emit voltageUpdated(lastVoltage);

    lastTemperature = 25.0f + (rand() % 20 - 10);
    emit temperatureUpdated(lastTemperature);

    if (elapsedSeconds > 10 && currentFlightPhase == 0) {
        currentFlightPhase = 1;
        emit flightPhaseUpdated(1);
    } else if (elapsedSeconds > 40 && currentFlightPhase == 1) {
        currentFlightPhase = 2;
        emit flightPhaseUpdated(2);
    } else if (elapsedSeconds > 70 && currentFlightPhase == 2) {
        currentFlightPhase = 3;
        emit flightPhaseUpdated(3);
    }

    int status = 1;
    if (elapsedSeconds < 5) {
        status = 1;
    } else if (elapsedSeconds < 60) {
        status = 2;
    } else if (elapsedSeconds < 80) {
        status = 3;
    } else {
        status = 6;
    }

    float speed = lastSpeed;

    _coreDataList.clear();
    _coreDataList.append(QString::number(static_cast<int>(elapsedSeconds)));
    _coreDataList.append(QString::number(Ax, 'f', 3));
    _coreDataList.append(QString::number(Ay, 'f', 3));
    _coreDataList.append(QString::number(Az, 'f', 3));
    _coreDataList.append(QString::number(Anx, 'f', 3));
    _coreDataList.append(QString::number(Any, 'f', 3));
    _coreDataList.append(QString::number(Anz, 'f', 3));
    _coreDataList.append(QString::number(lastAltitude, 'f', 3));
    _coreDataList.append(QString::number(status));
    _coreDataList.append(QString::number(speed, 'f', 3));
    _coreDataList.append(QString::number(lat, 'f', 7));
    _coreDataList.append(QString::number(lon, 'f', 7));

    emit telemetryUpdated(Ax, Ay, Az, Gx, Gy, Gz, lat, lon);
    coreDataUpdate();

    if (isLogging && dataStream) {
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
            .arg(lastAcceleration, 0, 'f', 3);
        *dataStream << QString("ALT,%1,%2\n")
            .arg(elapsedSeconds, 0, 'f', 3)
            .arg(lastAltitude, 0, 'f', 3);
        *dataStream << QString("SPEED,%1,%2\n")
            .arg(elapsedSeconds, 0, 'f', 3)
            .arg(lastSpeed, 0, 'f', 3);
        *dataStream << QString("VOLT,%1,%2\n")
            .arg(elapsedSeconds, 0, 'f', 3)
            .arg(lastVoltage, 0, 'f', 2);
        *dataStream << QString("TEMP,%1,%2\n")
            .arg(elapsedSeconds, 0, 'f', 3)
            .arg(lastTemperature, 0, 'f', 1);
        *dataStream << QString("PHASE,%1,%2\n")
            .arg(elapsedSeconds, 0, 'f', 3)
            .arg(currentFlightPhase);
        dataStream->flush();
    }
}

void SerialManagement::endConnection()
{
    if (simulationMode) {
        simulationTimer->stop();
    } else {
        if (_MCU->isOpen()) {
            _MCU->close();
        }
    }
    isConnected = false;
    hasPreviousGpsFix = false;
    previousTelemetryTime = 0.0f;
    verticalSpeedEstimate = 0.0f;
    qDebug() << "Conexión cerrada";
    emit microcontrollerConnectionStatus(false);
}

bool SerialManagement::getMicroConfirmation()
{
    return isConnected;
}

void SerialManagement::writeIntValue(int varIndex, int value)
{
    switch (varIndex){
    case 1:
        autoDataSaveStart = value;
        qDebug() << autoDataSaveStart;
        break;
    case 2:
        autoDataSaveFinish = value;
        qDebug() << autoDataSaveFinish;
    }
}

void SerialManagement::writeStringValue(int varIndex, QString text)
{
    switch (varIndex){
    case 1:
        filePath = text;
        qDebug() << filePath;
        break;
    case 2:
        fileName = text;
        qDebug() << text;
    }
}

void SerialManagement::changeRocketFrequency(QString value)
{
    rocketFrequency = value.trimmed();
    qDebug() << "Frecuencia actualizada:" << rocketFrequency;
}

void SerialManagement::createFile()
{
    if (isLogging) {
        qDebug() << "Hay un archivo de registro abierto";
        return;
    }

    QString localPath = QUrl(filePath).toLocalFile();
    if (localPath.isEmpty()) {
        localPath = filePath;
    }

    QDir dir(localPath);
    if (!dir.exists()) {
        qDebug() << "Ruta no existe:" << localPath;
        return;
    }

    QString route = dir.filePath(fileName + ".csv");
    dataFile = new QFile(route);
    if (dataFile->open(QIODevice::WriteOnly | QIODevice::Text)) {
        dataStream = new QTextStream(dataFile);
        *dataStream << "s" << "," 
                    << "Ax" << "," 
                    << "Ay" << "," 
                    << "Az" << "," 
                    << "Anz" << "," 
                    << "Anz" << "," 
                    << "Anz" << "," 
                    << "Alt" << "," 
                    << "Lat" << "," 
                    << "Lon" << "," 
                    << "Speed" << "," 
                    << "R. Status" << "," 
                    << "\n";

        isLogging = true;
        qDebug() << "Archivo abierto para escritura.";
    } else {
        qDebug() << "Error al abrir el archivo para escritura: ";
        isLogging = false;
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

void SerialManagement::writeDataFile()
{
    if (isLogging && dataStream) {
        //qDebug() << "Escribiendo en archivo";
        *dataStream << getActualTime() << ","
                    << getLastDataInList(1,-1) << "," // Ax
                    << getLastDataInList(2,-1) << "," // Ay
                    << getLastDataInList(3,-1) << "," // Az
                    << getLastDataInList(4,-1) << "," // Anx
                    << getLastDataInList(5,-1) << "," // Any
                    << getLastDataInList(6,-1) << "," // Anz
                    << getLastDataInList(7,-1) << "," // Alt
                    << getLastDataInList(10,-1) << "," // Lat
                    << getLastDataInList(11,-1) << "," // Lon
                    << getLastDataInList(12,-1) << "," // Speed
                    << getTelemetryStatus() << "," // Rocket Status
                    << "\n";
    } else{
        qDebug() << "No se pudo abrir el archivo";
    }
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

void SerialManagement::sendData(QString data) {     // To send data to the arduino
    if(_MCU -> isWritable()){  // Make sure that is possible to write through the serial port
        _MCU -> write(data.toUtf8());  // Send the data
        qDebug() << "Se envio " << data;
    } else {
        emit dataNotSent();
        qDebug() << "No se envio";
    }
}

void SerialManagement::sendFrequencyChange()
{
    QString data = QStringLiteral("l ") + rocketFrequency;
    if(_MCU -> isWritable()){  // Make sure that is possible to write through the serial port
        _MCU -> write(data.toUtf8());  // Send the data
        qDebug() << "Se envio el cambio de frequencia" << data;
    } else {
        emit dataNotSent();
        qDebug() << "No se envio el cambio de frequencia";
    }
}

float SerialManagement::getLastDataInList(int list, int pos)
{
    /*
     * Get the data in the position specified:
     * Use 1 for access the first data in the array (newest value)
     * Use -1 for acess the last data in the array (oldest value)
     * Use any oyjer number to acess the data in that pos (the greater the value, the oldest it is)
     *
     * The lists that can be acess are
     * 1 for Accel in X
     * 2 for Accel in Y
     * 3 for Accel in Z
     * 4 for Angle in X
     * 4 for Angle in Y
     * 6 for Angle in Z
     * 7 for current Alt
     * 8 for newer Lat values
     * 9 for newer Lon values
     * 10 for older Lat values
     * 11 for older Lon values
     * 12 for current speed

    */

    const QList<float>* dataList = nullptr;

    switch (list) {
    case 1: dataList = &_accelXDataListFloat; break;
    case 2: dataList = &_accelYDataListFloat; break;
    case 3: dataList = &_accelZDataListFloat; break;
    case 4: dataList = &_angleXDataListFloat; break;
    case 5: dataList = &_angleYDataListFloat; break;
    case 6: dataList = &_angleZDataListFloat; break;
    case 7: dataList = &_currentAltDataListFloat; break;
    case 8: dataList = &_olderLatValueList; break;
    case 9: dataList = &_olderLonValueList; break;
    case 10: dataList = &_newerLatValueList; break;
    case 11: dataList = &_newerLonValueList; break;
    case 12: dataList = &_currentSpeedDataListFloat; break;
    default:
        emit cannotAcessList();
        return 0.0f;
    }

    if (dataList->isEmpty()) {
        emit cannotAcessDataInList();
        return 0.0f;
    }

    if (pos == -1){
        return (*dataList).last();
    }else if (pos >0 && pos< dataList->size()){
        return (*dataList).at(pos-1);
    }else{
        emit cannotAcessDataInList();
        return 0.0f;
    }
}

float SerialManagement::getMaxMinDataInList(int list, bool maxBool)
{
    const QList<float>* dataList = nullptr;

    switch (list) {
    case 1: dataList = &_accelXDataListFloat; break;
    case 2: dataList = &_accelYDataListFloat; break;
    case 3: dataList = &_accelZDataListFloat; break;
    case 4: dataList = &_angleXDataListFloat; break;
    case 5: dataList = &_angleYDataListFloat; break;
    case 6: dataList = &_angleZDataListFloat; break;
    case 7: dataList = &_currentAltDataListFloat; break;
    case 8: dataList = &_olderLatValueList; break;
    case 9: dataList = &_olderLonValueList; break;
    case 10: dataList = &_newerLatValueList; break;
    case 11: dataList = &_newerLonValueList; break;
    case 12: dataList = &_currentSpeedDataListFloat; break;
    default:
        emit cannotAcessList();
        return 0.0f;
    }

    if (dataList->isEmpty()) {
        emit cannotAcessDataInList();
        return 0.0f;
    }

    if (maxBool){
        auto max = std::max_element(dataList->begin(), dataList->end());
        return *max;
    }else{
        auto min = std::min_element(dataList->begin(), dataList->end());
        return *min;
    }
}

float SerialManagement::getAbsMaxMinDataInLists(QList<int> lists, bool maxBool)
{
    QList<float> values;

    for (int list : lists) {
        switch (list) {
        case 1: values.append(_accelXDataListFloat); break;
        case 2: values.append(_accelYDataListFloat); break;
        case 3: values.append(_accelZDataListFloat); break;
        case 4: values.append(_angleXDataListFloat); break;
        case 5: values.append(_angleYDataListFloat); break;
        case 6: values.append(_angleZDataListFloat); break;
        case 7: values.append(_currentAltDataListFloat); break;
        case 8: values.append(_newerLatValueList); break;
        case 9: values.append(_newerLonValueList); break;
        case 10: values.append(_olderLatValueList); break;
        case 11: values.append(_olderLonValueList); break;
        case 12: values.append(_currentSpeedDataListFloat); break;
        default:
            emit cannotAcessList();
            return 0.0f;
        }
    }

    if (values.isEmpty()) {
        emit cannotAcessDataInList();
        return 0.0f;
    }

    if (maxBool){
        auto max = std::max_element(values.begin(), values.end());
        values.clear();
        return *max;
    }else{
        auto min = std::min_element(values.begin(), values.end());
        values.clear();
        return *min;
    }
}

float SerialManagement::getDataConvertedImperial(int dataWanted)
{
/*
    FUnction to get the data converted from SI to imperial units

    1 -> Last alttiude value
    2 -> Last speed value
*/
    switch(dataWanted){
        case 1:
            return getLastDataInList(7,-1)*3.28084;
        case 2:
            return getLastDataInList(12,-1)*3.28084;
        default:
            return 0.0f;
    }
}

QString SerialManagement::getActualTime()
{
    QTime current = QTime::currentTime();
    int elapsedMSecs = referenceTime.msecsTo(current);
    //qDebug() << "Elapsed MSecs" << elapsedMSecs;
    QTime elapsedTime(0, 0); // 00:00:00.000
    elapsedTime = elapsedTime.addMSecs(elapsedMSecs);
    QString formatted = elapsedTime.toString("mm:ss.zzz");
    //qDebug() << "Formated" << formatted;
    return formatted;
}

int SerialManagement::getTelemetryStatus()
{
    return telemetryStatus;
}

QString SerialManagement::getFilePath()
{
    return filePath;
}

QString SerialManagement::getFileName()
{
    return fileName;
}

QString SerialManagement::getFrequency()
{
    return rocketFrequency;
}

int SerialManagement::getEstApogeeAlt()
{
    return expectedApogeeAlt;
}

int SerialManagement::getEstMainAlt()
{
    return expectedMainAlt;
}

int SerialManagement::getEstTouchDownAlt()
{
    return expectedTouchDownAlt;
}