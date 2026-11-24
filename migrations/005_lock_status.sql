-- 005: only five statuses allowed. ALTER TABLE can't add a CHECK, so we rebuild bed_log.

-- 1. A new table: same columns as bed_log, plus the CHECK
CREATE TABLE bed_log_new (
    log_id   INTEGER PRIMARY KEY,
    bed_id   INTEGER NOT NULL REFERENCES bed(bed_id),
    log_date TEXT,
    status   TEXT CHECK (status IN ('seeded', 'sprouting', 'harvesting', 'fallow', 'failed'))
);

-- 2. Copy every row across
INSERT INTO bed_log_new (log_id, bed_id, log_date, status)
SELECT log_id, bed_id, log_date, status
FROM bed_log;

-- 3. Throw away the old table
DROP TABLE bed_log;

-- 4. Give the new table the old name
ALTER TABLE bed_log_new RENAME TO bed_log;
