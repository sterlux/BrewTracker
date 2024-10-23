-- backend/db/init.sql
CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    style VARCHAR(50),
    batch_size DECIMAL(4,2),
    original_gravity DECIMAL(4,3),
    final_gravity DECIMAL(4,3),
    ibu DECIMAL(4,1),
    abv DECIMAL(3,1),
    description TEXT,
    process_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    unit VARCHAR(20) NOT NULL,
    quantity_in_stock DECIMAL(6,2),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recipe_ingredients (
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    ingredient_id INTEGER REFERENCES ingredients(id) ON DELETE CASCADE,
    quantity DECIMAL(6,2) NOT NULL,
    timing VARCHAR(50),
    PRIMARY KEY (recipe_id, ingredient_id, timing)
);

CREATE TABLE batches (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id),
    brew_date DATE NOT NULL,
    fermentation_start_date DATE,
    bottling_date DATE,
    actual_og DECIMAL(4,3),
    actual_fg DECIMAL(4,3),
    yield_amount DECIMAL(4,2),
    status VARCHAR(50),
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fermentation_logs (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER REFERENCES batches(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    temperature DECIMAL(3,1),
    gravity DECIMAL(4,3),
    ph DECIMAL(3,1),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasting_notes (
    id SERIAL PRIMARY KEY,
    batch_id INTEGER REFERENCES batches(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    appearance TEXT,
    aroma TEXT,
    flavor TEXT,
    mouthfeel TEXT,
    overall_notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert some sample data
INSERT INTO ingredients (name, type, unit, quantity_in_stock) VALUES
    ('Pilsner Malt', 'malt', 'kg', 25.0),
    ('Cascade Hops', 'hops', 'g', 500.0),
    ('US-05 Yeast', 'yeast', 'unit', 10.0);

INSERT INTO recipes (name, style, batch_size, original_gravity, final_gravity, ibu, abv, description) VALUES
    ('Classic American Pale Ale', 'Pale Ale', 20.0, 1.052, 1.012, 35.0, 5.2, 'A classic American Pale Ale with Cascade hops');