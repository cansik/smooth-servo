// t = current time, b = start value, c = change in value, d = duration
public static float easeInQuad(float t, float b, float c, float d) {
  t /= d;
  return c*t*t + b;
}

public static float linearTween (float t, float b, float c, float d) {
  return c*t/d + b;
}

public static float easeOutQuad (float t, float b, float c, float d) {
  t /= d;
  return -c * t*(t-2) + b;
}