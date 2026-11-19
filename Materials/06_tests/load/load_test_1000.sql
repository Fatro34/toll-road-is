-- Нагрузочный тест ИС платных дорог (подраздел 7.3)
-- 1. Генерация 1000 записей проездов в таблице Trip
WITH RECURSIVE cnt(x) AS (
    SELECT 1
    UNION ALL
    SELECT x + 1 FROM cnt WHERE x < 1000
)
INSERT INTO Trip (VehicleId, EntryPointId, ExitPointId, EntryTime, ExitTime, Cost, Status, OperatorId)
SELECT
    t.VehicleId,
    t.EntryPointId,
    t.ExitPointId,
    datetime('2026-11-01 08:00:00', '+' || (x * 5) || ' minutes'),
    datetime('2026-11-01 08:45:00', '+' || (x * 5) || ' minutes'),
    (50.0 + (x % 100)) * 3.0,
    'paid',
    t.OperatorId
FROM cnt
CROSS JOIN (SELECT VehicleId, EntryPointId, ExitPointId, OperatorId FROM Trip LIMIT 1) t;

-- 2. Контрольная агрегирующая выборка по 1003 записям
SELECT Status, COUNT(*) AS TotalTrips, ROUND(SUM(Cost), 2) AS TotalRevenue, ROUND(AVG(Cost), 2) AS AvgCheck
FROM Trip
GROUP BY Status;
