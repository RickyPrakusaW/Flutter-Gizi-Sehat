import { useState, useEffect } from 'react';
import { BottomNavigation } from './components/bottom-navigation';
import { FloatingActionButton } from './components/floating-action-button';
import { HomeScreen } from './components/home-screen';
import { GrowthScreen } from './components/growth-screen';
import { MenuScreen } from './components/menu-screen';
import { ServicesScreen } from './components/services-screen';
import { AssistantScreen } from './components/assistant-screen';
import { ProfileScreen } from './components/profile-screen';
import { Onboarding } from './components/onboarding';
import { Auth } from './components/auth';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from './components/ui/dialog';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';
import { Label } from './components/ui/label';
import { Textarea } from './components/ui/textarea';
import { toast } from "sonner@2.0.3";
import { Toaster } from './components/ui/sonner';

type AppState = 'onboarding' | 'auth' | 'main';
type UserData = { name: string; email: string } | null;

export default function App() {
  const [appState, setAppState] = useState<AppState>('onboarding');
  const [userData, setUserData] = useState<UserData>(null);
  const [activeTab, setActiveTab] = useState('home');
  const [isDarkMode, setIsDarkMode] = useState(false);
  const [showMeasurementDialog, setShowMeasurementDialog] = useState(false);
  const [showPhotoDialog, setShowPhotoDialog] = useState(false);

  // Initialize app state from localStorage
  useEffect(() => {
    const hasSeenOnboarding = localStorage.getItem('gizisehat_onboarding_completed');
    const storedUserData = localStorage.getItem('gizisehat_user_data');
    const storedTheme = localStorage.getItem('gizisehat_theme');

    if (storedTheme === 'dark') {
      setIsDarkMode(true);
      document.documentElement.classList.add('dark');
    }

    if (hasSeenOnboarding && storedUserData) {
      setUserData(JSON.parse(storedUserData));
      setAppState('main');
    } else if (hasSeenOnboarding) {
      setAppState('auth');
    }
  }, []);

  // Handle theme changes
  useEffect(() => {
    if (isDarkMode) {
      document.documentElement.classList.add('dark');
      localStorage.setItem('gizisehat_theme', 'dark');
    } else {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('gizisehat_theme', 'light');
    }
  }, [isDarkMode]);

  const handleOnboardingComplete = () => {
    localStorage.setItem('gizisehat_onboarding_completed', 'true');
    setAppState('auth');
  };

  const handleAuthComplete = (user: { name: string; email: string }) => {
    setUserData(user);
    localStorage.setItem('gizisehat_user_data', JSON.stringify(user));
    setAppState('main');
  };

  const handleLogout = () => {
    setUserData(null);
    setActiveTab('home');
    localStorage.removeItem('gizisehat_user_data');
    localStorage.removeItem('gizisehat_onboarding_completed');
    setAppState('onboarding');
    toast.success("Berhasil keluar dari akun");
  };

  const toggleDarkMode = () => {
    setIsDarkMode(!isDarkMode);
    toast.success(isDarkMode ? "Mode terang diaktifkan" : "Mode gelap diaktifkan");
  };

  const handleAddMeasurement = () => {
    setShowMeasurementDialog(true);
  };

  const handleTakePhoto = () => {
    setShowPhotoDialog(true);
  };

  const handleSaveMeasurement = () => {
    setShowMeasurementDialog(false);
    toast.success("Pengukuran berhasil disimpan!");
  };

  const handleSavePhoto = () => {
    setShowPhotoDialog(false);
    toast.success("Foto makanan berhasil dianalisis!");
  };

  const handleNavigateToAssistant = () => {
    setActiveTab('assistant');
  };

  const renderActiveScreen = () => {
    switch (activeTab) {
      case 'home':
        return <HomeScreen onNavigateToAssistant={handleNavigateToAssistant} />;
      case 'growth':
        return <GrowthScreen />;
      case 'menu':
        return <MenuScreen />;
      case 'services':
        return <ServicesScreen />;
      case 'assistant':
        return <AssistantScreen />;
      case 'profile':
        return (
          <ProfileScreen 
            userData={userData!}
            isDarkMode={isDarkMode}
            onToggleDarkMode={toggleDarkMode}
            onLogout={handleLogout}
          />
        );
      default:
        return <HomeScreen onNavigateToAssistant={handleNavigateToAssistant} />;
    }
  };

  // Show onboarding
  if (appState === 'onboarding') {
    return <Onboarding onComplete={handleOnboardingComplete} />;
  }

  // Show auth
  if (appState === 'auth') {
    return <Auth onAuthComplete={handleAuthComplete} />;
  }

  // Main app
  return (
    <div className="min-h-screen bg-background relative">
      {/* Main Content */}
      <div className="relative z-10">
        {renderActiveScreen()}
      </div>

      {/* Bottom Navigation */}
      <BottomNavigation activeTab={activeTab} onTabChange={setActiveTab} />

      {/* Floating Action Button - only show on relevant tabs */}
      {(activeTab === 'growth' || activeTab === 'menu') && (
        <FloatingActionButton 
          activeTab={activeTab}
          onAddMeasurement={handleAddMeasurement}
          onTakePhoto={handleTakePhoto}
        />
      )}

      {/* Measurement Dialog */}
      <Dialog open={showMeasurementDialog} onOpenChange={setShowMeasurementDialog}>
        <DialogContent className="sm:max-w-[425px] mx-4">
          <DialogHeader>
            <DialogTitle>Tambah Pengukuran</DialogTitle>
            <DialogDescription>
              Masukkan data pengukuran terbaru untuk anak Anda
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-4 py-4">
            <div className="grid gap-2">
              <Label htmlFor="child-select">Pilih Anak</Label>
              <select className="flex h-10 w-full rounded-md border border-input bg-input-background px-3 py-2 text-sm ring-offset-background">
                <option>Sari (8 bulan)</option>
                <option>Budi (2 tahun 4 bulan)</option>
              </select>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="grid gap-2">
                <Label htmlFor="weight">Berat Badan (kg)</Label>
                <Input id="weight" placeholder="8.0" />
              </div>
              <div className="grid gap-2">
                <Label htmlFor="height">Tinggi Badan (cm)</Label>
                <Input id="height" placeholder="70" />
              </div>
            </div>
            <div className="grid gap-2">
              <Label htmlFor="muac">MUAC - Lingkar Lengan (cm)</Label>
              <Input id="muac" placeholder="13.5" />
            </div>
            <div className="grid gap-2">
              <Label htmlFor="notes">Catatan (opsional)</Label>
              <Textarea id="notes" placeholder="Kondisi anak saat pengukuran..." />
            </div>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" onClick={() => setShowMeasurementDialog(false)} className="flex-1">
              Batal
            </Button>
            <Button onClick={handleSaveMeasurement} className="flex-1">
              Simpan
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      {/* Photo Analysis Dialog */}
      <Dialog open={showPhotoDialog} onOpenChange={setShowPhotoDialog}>
        <DialogContent className="sm:max-w-[425px] mx-4">
          <DialogHeader>
            <DialogTitle>Analisis Foto Makanan</DialogTitle>
            <DialogDescription>
              AI akan menganalisis kandungan gizi dari foto makanan
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-4 py-4">
            <div className="grid gap-2">
              <Label>Upload Foto</Label>
              <div className="border-2 border-dashed border-border rounded-lg p-8 text-center">
                <div className="mx-auto w-12 h-12 bg-muted rounded-full flex items-center justify-center mb-4">
                  📷
                </div>
                <p className="text-sm text-muted-foreground mb-2">Ketuk untuk ambil foto atau pilih dari galeri</p>
                <Button variant="outline" size="sm">Pilih Foto</Button>
              </div>
            </div>
            <div className="grid gap-2">
              <Label htmlFor="portion">Perkiraan Porsi</Label>
              <select className="flex h-10 w-full rounded-md border border-input bg-input-background px-3 py-2 text-sm ring-offset-background">
                <option>1 porsi (100g)</option>
                <option>1/2 porsi (50g)</option>
                <option>2 porsi (200g)</option>
              </select>
            </div>
          </div>
          <div className="flex gap-2">
            <Button variant="outline" onClick={() => setShowPhotoDialog(false)} className="flex-1">
              Batal
            </Button>
            <Button onClick={handleSavePhoto} className="flex-1">
              Analisis
            </Button>
          </div>
        </DialogContent>
      </Dialog>

      <Toaster />
    </div>
  );
}