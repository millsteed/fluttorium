CREATE TABLE users (
    id TEXT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    salt TEXT NOT NULL
);

CREATE TABLE sessions (
    id TEXT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    token TEXT NOT NULL,
    user_id TEXT NOT NULL REFERENCES users (id)
);

CREATE TABLE categories (
    id TEXT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    sort_order INT NOT NULL,
    title TEXT NOT NULL
);

INSERT INTO categories
    (id, created_at, updated_at, sort_order, title)
VALUES
    ('3wyLyjavsl5MJRmW', '2024-01-01 12:00', '2024-01-01 12:00', 1, 'General'),
    ('ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 2, 'Flutter');

CREATE TABLE forums (
    id TEXT PRIMARY KEY,
    category_id TEXT NOT NULL REFERENCES categories (id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    sort_order INT NOT NULL,
    title TEXT NOT NULL
);

INSERT INTO forums
    (id, category_id, created_at, updated_at, sort_order, title)
VALUES
    ('OBNNmHmpMdBtqYk4', '3wyLyjavsl5MJRmW', '2024-01-01 12:00', '2024-01-01 12:00', 1, 'Announcements'),
    ('nJ8qALENDPCWWIN9', '3wyLyjavsl5MJRmW', '2024-01-01 12:00', '2024-01-01 12:00', 2, 'General'),
    ('wAWupMZoDZkYQigP', '3wyLyjavsl5MJRmW', '2024-01-01 12:00', '2024-01-01 12:00', 3, 'Feedback'),
    ('iliKaIYRYvB86zvR', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 1, 'News'),
    ('aUIv9ZfoqbTHAotp', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 2, 'Tutorials'),
    ('ILajgOLwxjqveMgz', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 3, 'Packages'),
    ('j5Ry0vJMDmgtiK4o', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 4, 'Projects'),
    ('hzj7ATQfHiPFx53n', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 5, 'Groups'),
    ('6B5cdhRxmDAzJGe3', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 6, 'Jobs'),
    ('TmI9gYUMEEigL0FO', 'ENTG8uWbnj8to4Ht', '2024-01-01 12:00', '2024-01-01 12:00', 7, 'Help');

CREATE TABLE threads (
    id TEXT PRIMARY KEY,
    forum_id TEXT NOT NULL REFERENCES forums (id),
    user_id TEXT NOT NULL REFERENCES users (id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    title TEXT NOT NULL
);

CREATE TABLE posts (
    id TEXT PRIMARY KEY,
    thread_id TEXT NOT NULL REFERENCES threads (id),
    user_id TEXT NOT NULL REFERENCES users (id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    message TEXT NOT NULL
);
