params ["_data"];

private _countArray = [[],[]];
private _classNames = _countArray select 0;
private _counts = _countArray select 1;

{
    _className = _x;
    _id = _classNames find _className;

    if (_id < 0) then {
        _classNames pushBack _className;
        _counts pushBack 1;
    } else {
        _counts set [_id,(_counts select _id) + 1];
    };

    false
} count _data;


_countArray
