Config = {}

-- Drift point settings
Config.DriftPoint = {
    MinSpeed = 50.0, -- Minimum speed to start earning points
    MaxSpeed = 150.0, -- Maximum speed to earn points
    PointMultiplier = 1.0, -- Multiplier for points earned
    Cooldown = 5000, -- Cooldown between points in milliseconds
    Reward = 100 -- Reward for earning points
}

-- Database settings
Config.Database = {
    TableName = 'drift_points'
}