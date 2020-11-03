
/// Return a result based on the [condition]
///
/// This method return a result base on the [bool] [condition]:
/// if condition is true [first] will be returned,
/// if condition is false [second] will be returned,
/// if the condition is null will be returned [def].
/// If [def] is null [first] will be returned instead.
T bqtop<T>(bool condition, T first, T second, [T def]) {
  if (condition == null)
    return def ?? first;
  return condition? first: second;
}