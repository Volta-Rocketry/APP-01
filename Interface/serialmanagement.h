#ifndef SERIALMANAGEMENT_H
#define SERIALMANAGEMENT_H

#include <QObject>

class serialmanagement : public QObject
{
    Q_OBJECT
public:
    explicit serialmanagement(QObject *parent = nullptr);

signals:
};

#endif // SERIALMANAGEMENT_H
