# Декартово Дерево на asm

Декартово дерево (ДД) — структура данных, поддерживающия вставку, удаление и поиск элементов в среднем за логарифмическое время. Состоит из пар $(x, y)$, где $x$ — ключи (бинарное дерево), а $y$ — приоритеты (куча). Название treap взято из слова tree и heap, так как ДД является и тем, и другим одновременно.

## Задача

Все мы не один раз писали ДД на языке С++ на олимпиадах или курсах по АиСД. Но писал ли его кто-то на языке ассемблера? Эта структура данных является достаточно базовым, поэтому хочется его пощупать на уровне регистров, сравнить по скорости с другими ЯП, а также попробовать обогнать современные компиляторы по скорости в бенчмарках.

ДД должно поддерживать следующие методы:
* add $x$ — добавить ключ $x$ в дерево.
* remove $x$ — удалить ключ $x$ из дерева (если его нет, то ничего не делать).
* contains $x$ — проверить ключ $x$ на наличие в дереве.
* find_by_order $k$ — вернуть $k$-ую порядковую статистику.
* order_of_key $x$ — сказать порядок элемента $x$.

Для выполнения данных методов ДД должно уметь делать две операции:
1. $Merge(l, r)$ — слить два ДД $l$ и $r$ в один и вернуть его. Для этого все ключи $l$ должны быть меньше, чем все ключи $r$.
2. $Split(x, k)$ — разрезать ДД $x$ на два по ключу $k$ так, чтобы в одном были все ключи $\le k$, а в другом $> k$.

Каждый метод будет вызывать операции split/merge, у каждого из которых математическое ожидание работы логарифм.

## Цели проекта

* Реализовать Декартово Дерево (ДД) на языке ассемблера (x86, AT&T синтаксис).
* Сравнить реализацию на С/C++, python как по структуре кода, так и по скорости в бенчмарках.
* Глубже разобраться в asm.

## Распределение задач

Project manager: Низамов Айнур \
Team lead: Низамов Айнур \
Разработчик: Низамов Айнур \
Тестировщик: Низамов Айнур

## Проделанная работа на конец 1 семестра

1. Написан основной функционал: структура, создание новых вершин и пр.
2. Написаны операции split/merge.
3. Реализована функция add.

## Что дальше?

Дописать функции и сделать функцию генерации рандомного числа. Провести бенчмарки и сравнить с другими ЯП.
