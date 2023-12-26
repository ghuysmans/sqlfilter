SELECT
  CASE
    WHEN v_implicit=v_left_assoc THEN 'left-associative'
    WHEN v_implicit=v_right_assoc THEN 'right-associative'
    ELSE 'whatever'
  END interpretation
FROM (
  SELECT
  0 BETWEEN 0 AND 0 AND 0   v_implicit,
  (0 BETWEEN 0 AND 0) AND 0 v_left_assoc,
  0 BETWEEN 0 AND (0 AND 0) v_right_assoc
) t;
