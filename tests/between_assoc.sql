SELECT
  CASE
    WHEN v_implicit=v_left_assoc THEN 'left-associative'
    WHEN v_implicit=v_right_assoc THEN 'right-associative'
    ELSE 'whatever'
  END interpretation
FROM (
  SELECT
  1 BETWEEN 0 AND 2 BETWEEN 0 AND 1   v_implicit,
  (1 BETWEEN 0 AND 2) BETWEEN 0 AND 1 v_left_assoc,
  1 BETWEEN 0 AND (2 BETWEEN 0 AND 1) v_right_assoc
) t;
