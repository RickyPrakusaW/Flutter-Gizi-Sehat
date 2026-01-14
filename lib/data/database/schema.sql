-- ============================================
-- GiziSehat Database Schema
-- ============================================
-- Database untuk menyimpan data pengguna, anak, dan pemantauan pertumbuhan
-- Mengikuti standar Supabase dengan Row Level Security (RLS)

-- ============================================
-- TABLE: auth.users (built-in Supabase)
-- ============================================
-- Tabel otomatis dari Supabase Auth, tidak perlu dibuat manual

-- ============================================
-- TABLE: public.user_profiles (Profil Orang Tua)
-- ============================================
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  
  -- Data Orang Tua
  full_name VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  birth_date DATE,
  
  -- Alamat
  address TEXT,
  city VARCHAR(100),
  province VARCHAR(100),
  postal_code VARCHAR(10),
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT unique_user_id UNIQUE(user_id)
);

-- ============================================
-- TABLE: public.children (Data Anak)
-- ============================================
CREATE TABLE IF NOT EXISTS public.children (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID NOT NULL REFERENCES public.user_profiles(id) ON DELETE CASCADE,
  
  -- Data Anak
  full_name VARCHAR(255) NOT NULL,
  birth_date DATE NOT NULL,
  gender VARCHAR(10),
  blood_type VARCHAR(10),
  
  -- Identitas
  birth_certificate_number VARCHAR(50),
  
  -- Metadata
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: public.growth_measurements (Pemantauan Pertumbuhan)
-- ============================================
CREATE TABLE IF NOT EXISTS public.growth_measurements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  child_id UUID NOT NULL REFERENCES public.children(id) ON DELETE CASCADE,
  
  -- Pengukuran Antropometri
  measurement_date DATE NOT NULL,
  weight_kg DECIMAL(5, 2) NOT NULL,
  height_cm DECIMAL(5, 1) NOT NULL,
  arm_circumference_cm DECIMAL(4, 1),
  
  -- Z-Score (dihitung dari WHO standards)
  weight_for_age_z_score DECIMAL(4, 2),
  height_for_age_z_score DECIMAL(4, 2),
  weight_for_height_z_score DECIMAL(4, 2),
  
  -- Status Gizi (berdasarkan z-score)
  nutritional_status VARCHAR(50), -- "Normal", "Gizi Kurang", "Stunting", dll
  
  -- Catatan
  notes TEXT,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: public.nutrition_plans (Rencana Gizi)
-- ============================================
CREATE TABLE IF NOT EXISTS public.nutrition_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  child_id UUID NOT NULL REFERENCES public.children(id) ON DELETE CASCADE,
  
  -- Rencana
  title VARCHAR(255) NOT NULL,
  description TEXT,
  daily_calories INTEGER,
  
  -- Periode
  start_date DATE NOT NULL,
  end_date DATE,
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: public.food_logs (Catatan Makanan Harian)
-- ============================================
CREATE TABLE IF NOT EXISTS public.food_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  child_id UUID NOT NULL REFERENCES public.children(id) ON DELETE CASCADE,
  
  -- Log Makanan
  log_date DATE NOT NULL,
  meal_type VARCHAR(50), -- "Sarapan", "Makan Siang", "Makan Malam", "Snack"
  food_name VARCHAR(255) NOT NULL,
  quantity VARCHAR(100),
  calories INTEGER,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: public.education_articles (Artikel Edukasi Gizi)
-- ============================================
CREATE TABLE IF NOT EXISTS public.education_articles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Konten
  title VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  excerpt TEXT,
  content TEXT NOT NULL,
  image_url VARCHAR(500),
  
  -- Kategori
  category VARCHAR(100), -- "Tips Gizi", "Resep Anak", "Tanda Stunting", dll
  
  -- Metadata
  author_id UUID REFERENCES auth.users(id),
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMP,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: public.health_services (Layanan Kesehatan)
-- ============================================
CREATE TABLE IF NOT EXISTS public.health_services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Info Layanan
  name VARCHAR(255) NOT NULL,
  service_type VARCHAR(100), -- "Puskesmas", "Posyandu", "Rumah Sakit"
  address TEXT NOT NULL,
  
  -- Lokasi
  city VARCHAR(100),
  province VARCHAR(100),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  
  -- Kontak
  phone_number VARCHAR(20),
  email VARCHAR(255),
  website VARCHAR(255),
  
  -- Jam Operasional
  operating_hours TEXT,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE: public.ai_conversations (Chat AI Assistant)
-- ============================================
CREATE TABLE IF NOT EXISTS public.ai_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  child_id UUID REFERENCES public.children(id) ON DELETE SET NULL,
  
  -- Chat
  user_message TEXT NOT NULL,
  assistant_response TEXT NOT NULL,
  conversation_context JSONB, -- Context untuk follow-up questions
  
  -- Metadata
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- ROW LEVEL SECURITY (RLS) - Keamanan Data
-- ============================================

-- Enable RLS di semua tabel
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.growth_measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nutrition_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.food_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_conversations ENABLE ROW LEVEL SECURITY;

-- RLS Policy: user_profiles
CREATE POLICY "Users can only view/edit own profile"
  ON public.user_profiles
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: children
CREATE POLICY "Users can only view/edit children of own profile"
  ON public.children
  FOR ALL
  USING (parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid()))
  WITH CHECK (parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid()));

-- RLS Policy: growth_measurements
CREATE POLICY "Users can only view measurements of own children"
  ON public.growth_measurements
  FOR ALL
  USING (child_id IN (SELECT id FROM public.children WHERE parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid())))
  WITH CHECK (child_id IN (SELECT id FROM public.children WHERE parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid())));

-- RLS Policy: nutrition_plans
CREATE POLICY "Users can only view nutrition plans of own children"
  ON public.nutrition_plans
  FOR ALL
  USING (child_id IN (SELECT id FROM public.children WHERE parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid())))
  WITH CHECK (child_id IN (SELECT id FROM public.children WHERE parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid())));

-- RLS Policy: food_logs
CREATE POLICY "Users can only view food logs of own children"
  ON public.food_logs
  FOR ALL
  USING (child_id IN (SELECT id FROM public.children WHERE parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid())))
  WITH CHECK (child_id IN (SELECT id FROM public.children WHERE parent_id IN (SELECT id FROM public.user_profiles WHERE user_id = auth.uid())));

-- RLS Policy: health_services (public read, no edit)
CREATE POLICY "Health services are publicly readable"
  ON public.health_services
  FOR SELECT
  USING (true);

-- RLS Policy: ai_conversations
CREATE POLICY "Users can only view own conversations"
  ON public.ai_conversations
  FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- INDEXES - untuk performa query
-- ============================================
CREATE INDEX idx_user_profiles_user_id ON public.user_profiles(user_id);
CREATE INDEX idx_children_parent_id ON public.children(parent_id);
CREATE INDEX idx_growth_child_id ON public.growth_measurements(child_id);
CREATE INDEX idx_growth_date ON public.growth_measurements(measurement_date);
CREATE INDEX idx_nutrition_plans_child_id ON public.nutrition_plans(child_id);
CREATE INDEX idx_food_logs_child_id ON public.food_logs(child_id);
CREATE INDEX idx_food_logs_date ON public.food_logs(log_date);
CREATE INDEX idx_ai_conversations_user_id ON public.ai_conversations(user_id);
