#include "labyrinth.h"

Labyrinth::Labyrinth(QObject *parent) : QObject(parent)
{
}

void Labyrinth::addField(int x, int y, QVariant field)
{
    fieldMap.insert(qMakePair(x, y), field);
}

QVariant Labyrinth::getField(int x, int y)
{
    return fieldMap.value(qMakePair(x, y), QVariant());
}
