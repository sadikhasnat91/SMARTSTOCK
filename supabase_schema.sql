-- ============================================================================
-- SmartStock: Complete Supabase PostgreSQL Schema with Permissive Access (Anon & Auth)
-- Run this whole script in your Supabase SQL Editor:
-- https://supabase.com/dashboard/project/xzjtxakxubxvldfmucxb/sql/new
-- ============================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS & PROFILES
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'Staff',
    department TEXT NOT NULL DEFAULT 'Warehouse Operations',
    phone TEXT,
    avatar_url TEXT,
    status TEXT NOT NULL DEFAULT 'Active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 2. WAREHOUSES & LOCATIONS
CREATE TABLE IF NOT EXISTS public.warehouses (
    id TEXT PRIMARY KEY,
    code TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    type TEXT NOT NULL DEFAULT 'Distribution',
    address TEXT NOT NULL,
    manager TEXT NOT NULL,
    phone TEXT NOT NULL,
    total_area NUMERIC(10, 2) NOT NULL DEFAULT 5000,
    used_area NUMERIC(10, 2) NOT NULL DEFAULT 3000,
    capacity_pct NUMERIC(5, 2) NOT NULL DEFAULT 60.0,
    zones_count INT NOT NULL DEFAULT 3,
    locations_count INT NOT NULL DEFAULT 100,
    products_count INT NOT NULL DEFAULT 150,
    status TEXT NOT NULL DEFAULT 'Active',
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Seed Warehouses so Foreign Keys never fail
INSERT INTO public.warehouses (id, code, name, type, address, manager, phone)
VALUES 
  ('WH-001', 'WH-Main', 'Main Distribution Center', 'Distribution', '142 Industrial Park Blvd, Dhaka', 'Ahmed Rahman', '+880-2-9876543'),
  ('WH-002', 'WH-East', 'East Regional Warehouse', 'Regional', '88 Commerce Street, Narayanganj', 'Sarah Khan', '+880-2-7654321'),
  ('WH-003', 'WH-West', 'West Regional Warehouse', 'Regional', '55 Trade Zone, Savar', 'Mike Torres', '+880-2-5432190'),
  ('WH-004', 'WH-Cold', 'Cold Storage Depot', 'Cold Storage', '12 Airport Cargo Area, Dhaka', 'Dr. Tanvir Hasan', '+880-2-4321098')
ON CONFLICT (code) DO NOTHING;

CREATE TABLE IF NOT EXISTS public.warehouse_locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code) ON DELETE CASCADE,
    zone TEXT NOT NULL,
    aisle TEXT NOT NULL,
    rack TEXT NOT NULL,
    shelf TEXT NOT NULL,
    bin TEXT NOT NULL,
    location_code TEXT UNIQUE NOT NULL,
    is_occupied BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 3. PRODUCT CATEGORIES & PRODUCTS
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    icon TEXT DEFAULT 'category_outlined',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.products (
    id TEXT PRIMARY KEY,
    sku TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    brand TEXT NOT NULL,
    unit TEXT NOT NULL DEFAULT 'PCS',
    cost_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    selling_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    stock INT NOT NULL DEFAULT 0,
    min_stock INT NOT NULL DEFAULT 10,
    max_stock INT NOT NULL DEFAULT 200,
    warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code) ON UPDATE CASCADE,
    status TEXT NOT NULL DEFAULT 'In Stock',
    barcode TEXT UNIQUE NOT NULL,
    description TEXT,
    weight NUMERIC(8, 2),
    dimensions TEXT,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    CONSTRAINT chk_stock_non_negative CHECK (stock >= 0),
    CONSTRAINT chk_cost_price CHECK (cost_price >= 0),
    CONSTRAINT chk_selling_price CHECK (selling_price >= 0)
);

-- 4. SUPPLIERS & PROCUREMENT
CREATE TABLE IF NOT EXISTS public.suppliers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    contact_person TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    country TEXT NOT NULL,
    category TEXT NOT NULL,
    rating NUMERIC(3, 2) NOT NULL DEFAULT 4.0,
    total_orders INT NOT NULL DEFAULT 0,
    total_value NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    on_time_delivery_rate NUMERIC(5, 2) NOT NULL DEFAULT 95.0,
    quality_score NUMERIC(5, 2) NOT NULL DEFAULT 95.0,
    status TEXT NOT NULL DEFAULT 'Active',
    payment_terms TEXT NOT NULL DEFAULT 'Net 30',
    lead_time TEXT NOT NULL DEFAULT '7-10 days',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.purchase_orders (
    id TEXT PRIMARY KEY,
    supplier_id TEXT NOT NULL REFERENCES public.suppliers(id) ON UPDATE CASCADE,
    supplier_name TEXT NOT NULL,
    items_count INT NOT NULL DEFAULT 1,
    subtotal NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    status TEXT NOT NULL DEFAULT 'Pending',
    requested_by TEXT NOT NULL,
    approved_by TEXT,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    delivery_date DATE,
    warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code) ON UPDATE CASCADE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.purchase_requests (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    requester TEXT NOT NULL,
    department TEXT NOT NULL,
    priority TEXT NOT NULL DEFAULT 'Medium',
    status TEXT NOT NULL DEFAULT 'Pending',
    estimated_cost NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 5. CUSTOMERS & SALES
CREATE TABLE IF NOT EXISTS public.customers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    contact_person TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    address TEXT,
    type TEXT NOT NULL DEFAULT 'Business',
    status TEXT NOT NULL DEFAULT 'Active',
    credit_limit NUMERIC(12, 2) NOT NULL DEFAULT 25000.00,
    total_orders INT NOT NULL DEFAULT 0,
    lifetime_revenue NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.sales_orders (
    id TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES public.customers(id) ON UPDATE CASCADE,
    customer_name TEXT NOT NULL,
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00,
    items_count INT NOT NULL DEFAULT 1,
    status TEXT NOT NULL DEFAULT 'Pending',
    payment_status TEXT NOT NULL DEFAULT 'Unpaid',
    warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code) ON UPDATE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 6. STOCK MOVEMENTS & TRANSFERS
CREATE TABLE IF NOT EXISTS public.stock_transfers (
    id TEXT PRIMARY KEY,
    source_warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code),
    dest_warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code),
    sku TEXT NOT NULL,
    product_name TEXT NOT NULL,
    quantity INT NOT NULL,
    status TEXT NOT NULL DEFAULT 'Approved',
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    expected_date DATE NOT NULL DEFAULT CURRENT_DATE + INTERVAL '3 days',
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.stock_movements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id TEXT NOT NULL REFERENCES public.products(id) ON DELETE CASCADE,
    sku TEXT NOT NULL,
    product_name TEXT NOT NULL,
    movement_type TEXT NOT NULL,
    quantity INT NOT NULL,
    reason TEXT NOT NULL,
    warehouse_code TEXT NOT NULL REFERENCES public.warehouses(code) ON UPDATE CASCADE,
    performed_by TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- 7. AUDIT LOGS
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_name TEXT NOT NULL,
    action TEXT NOT NULL,
    module TEXT NOT NULL,
    details TEXT NOT NULL,
    ip_address TEXT DEFAULT '127.0.0.1',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ============================================================================
-- 8. GRANT PRIVILEGES TO anon & authenticated
-- ============================================================================
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated, service_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;

-- ============================================================================
-- 9. ROW LEVEL SECURITY (RLS) POLICIES - OPEN FOR DEMO & APP USAGE
-- ============================================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.warehouse_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_transfers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stock_movements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if any to avoid collision
DROP POLICY IF EXISTS "Full access for all on warehouses" ON public.warehouses;
DROP POLICY IF EXISTS "Full access for all on products" ON public.products;
DROP POLICY IF EXISTS "Full access for all on categories" ON public.categories;
DROP POLICY IF EXISTS "Full access for all on suppliers" ON public.suppliers;
DROP POLICY IF EXISTS "Full access for all on customers" ON public.customers;
DROP POLICY IF EXISTS "Full access for all on sales_orders" ON public.sales_orders;
DROP POLICY IF EXISTS "Full access for all on purchase_orders" ON public.purchase_orders;
DROP POLICY IF EXISTS "Full access for all on purchase_requests" ON public.purchase_requests;
DROP POLICY IF EXISTS "Full access for all on stock_transfers" ON public.stock_transfers;
DROP POLICY IF EXISTS "Full access for all on stock_movements" ON public.stock_movements;
DROP POLICY IF EXISTS "Full access for all on audit_logs" ON public.audit_logs;
DROP POLICY IF EXISTS "Full access for all on profiles" ON public.profiles;

CREATE POLICY "Full access for all on warehouses" ON public.warehouses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on products" ON public.products FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on categories" ON public.categories FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on suppliers" ON public.suppliers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on customers" ON public.customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on sales_orders" ON public.sales_orders FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on purchase_orders" ON public.purchase_orders FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on purchase_requests" ON public.purchase_requests FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on stock_transfers" ON public.stock_transfers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on stock_movements" ON public.stock_movements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on audit_logs" ON public.audit_logs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Full access for all on profiles" ON public.profiles FOR ALL USING (true) WITH CHECK (true);
