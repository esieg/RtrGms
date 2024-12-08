#ifndef LABYRINTH_H
#define LABYRINTH_H

#include <QObject>
#include <QMap>
#include <QVariant>

class Labyrinth : public QObject
{
    Q_OBJECT
public:
    explicit Labyrinth(QObject *parent = nullptr);

    Q_INVOKABLE void addField(int x, int y, QVariant field);
    Q_INVOKABLE QVariant getField(int x, int y);

private:
    QMap<QPair<int, int>, QVariant> fieldMap;
};

#endif // LABYRINTH_H
