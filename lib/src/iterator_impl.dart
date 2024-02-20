class IteratorImpl<T> implements Iterator<T> {
  IteratorImpl(this._items);

  int _index = -1;

  final List<T> _items;

  @override
  T get current => _items[_index];

  @override
  bool moveNext() {
    _index++;
    return _index < _items.length;
  }
}
