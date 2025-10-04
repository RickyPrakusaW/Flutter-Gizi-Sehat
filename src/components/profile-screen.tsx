import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Button } from './ui/button';
import { Switch } from './ui/switch';
import { Label } from './ui/label';
import { Badge } from './ui/badge';
import { Separator } from './ui/separator';
import { 
  User, 
  Mail, 
  Baby, 
  Plus, 
  Settings, 
  Globe, 
  Moon, 
  Sun,
  LogOut,
  Edit3,
  Bell,
  Shield,
  HelpCircle,
  Heart
} from 'lucide-react';

interface ProfileScreenProps {
  userData: { name: string; email: string };
  isDarkMode: boolean;
  onToggleDarkMode: () => void;
  onLogout: () => void;
}

export function ProfileScreen({ userData, isDarkMode, onToggleDarkMode, onLogout }: ProfileScreenProps) {
  const [children] = useState([
    {
      id: 1,
      name: 'Sari',
      age: '8 bulan',
      gender: 'Perempuan',
      birthDate: '2023-05-15',
      status: 'Normal'
    },
    {
      id: 2,
      name: 'Budi',
      age: '2 tahun 4 bulan',
      gender: 'Laki-laki',
      birthDate: '2021-09-10',
      status: 'Berisiko'
    }
  ]);

  const [preferences, setPreferences] = useState({
    language: 'Bahasa Indonesia',
    unit: 'Metric (kg, cm)',
    notifications: true,
    dataSharing: false
  });

  const handleLanguageChange = () => {
    setPreferences(prev => ({
      ...prev,
      language: prev.language === 'Bahasa Indonesia' ? 'English' : 'Bahasa Indonesia'
    }));
  };

  const handleUnitChange = () => {
    setPreferences(prev => ({
      ...prev,
      unit: prev.unit === 'Metric (kg, cm)' ? 'Imperial (lb, in)' : 'Metric (kg, cm)'
    }));
  };

  return (
    <div className="pb-20 px-4 pt-6 space-y-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-6">
        <div className="h-20 w-20 mx-auto mb-4 rounded-full bg-primary/10 flex items-center justify-center">
          <User className="h-10 w-10 text-primary" />
        </div>
        <h1 className="text-2xl font-semibold text-foreground">{userData.name}</h1>
        <p className="text-muted-foreground">{userData.email}</p>
        <Button variant="ghost" size="sm" className="mt-2">
          <Edit3 className="h-4 w-4 mr-2" />
          Edit Profil
        </Button>
      </div>

      {/* Children Management */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Baby className="h-5 w-5" />
            <span>Kelola Anak</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {children.map((child) => (
            <div key={child.id} className="flex items-center justify-between p-3 bg-muted/30 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center">
                  <Baby className="h-5 w-5 text-primary" />
                </div>
                <div>
                  <p className="font-medium">{child.name}</p>
                  <p className="text-sm text-muted-foreground">{child.age} • {child.gender}</p>
                </div>
              </div>
              <div className="text-right">
                <Badge 
                  className={child.status === 'Normal' 
                    ? 'bg-green-100 text-green-800' 
                    : 'bg-yellow-100 text-yellow-800'
                  }
                >
                  {child.status}
                </Badge>
                <Button variant="ghost" size="sm" className="h-auto p-1 mt-1">
                  <Edit3 className="h-3 w-3" />
                </Button>
              </div>
            </div>
          ))}
          
          <Button variant="outline" className="w-full mt-3">
            <Plus className="h-4 w-4 mr-2" />
            Tambah Anak
          </Button>
        </CardContent>
      </Card>

      {/* Theme Settings */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Settings className="h-5 w-5" />
            <span>Pengaturan Tampilan</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              {isDarkMode ? (
                <Moon className="h-5 w-5 text-muted-foreground" />
              ) : (
                <Sun className="h-5 w-5 text-muted-foreground" />
              )}
              <div>
                <Label htmlFor="dark-mode">Mode Gelap</Label>
                <p className="text-sm text-muted-foreground">
                  {isDarkMode ? 'Aktif' : 'Nonaktif'}
                </p>
              </div>
            </div>
            <Switch
              id="dark-mode"
              checked={isDarkMode}
              onCheckedChange={onToggleDarkMode}
            />
          </div>
        </CardContent>
      </Card>

      {/* App Preferences */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Globe className="h-5 w-5" />
            <span>Preferensi</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div>
              <Label>Bahasa</Label>
              <p className="text-sm text-muted-foreground">{preferences.language}</p>
            </div>
            <Button variant="outline" size="sm" onClick={handleLanguageChange}>
              Ubah
            </Button>
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div>
              <Label>Satuan Ukuran</Label>
              <p className="text-sm text-muted-foreground">{preferences.unit}</p>
            </div>
            <Button variant="outline" size="sm" onClick={handleUnitChange}>
              Ubah
            </Button>
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Bell className="h-5 w-5 text-muted-foreground" />
              <div>
                <Label htmlFor="notifications">Notifikasi</Label>
                <p className="text-sm text-muted-foreground">
                  Pengingat timbang dan jadwal
                </p>
              </div>
            </div>
            <Switch
              id="notifications"
              checked={preferences.notifications}
              onCheckedChange={(checked) => 
                setPreferences(prev => ({ ...prev, notifications: checked }))
              }
            />
          </div>

          <Separator />

          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <Shield className="h-5 w-5 text-muted-foreground" />
              <div>
                <Label htmlFor="data-sharing">Berbagi Data Anonim</Label>
                <p className="text-sm text-muted-foreground">
                  Membantu riset stunting
                </p>
              </div>
            </div>
            <Switch
              id="data-sharing"
              checked={preferences.dataSharing}
              onCheckedChange={(checked) => 
                setPreferences(prev => ({ ...prev, dataSharing: checked }))
              }
            />
          </div>
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <div className="space-y-3">
        <Button variant="outline" className="w-full justify-start h-12">
          <HelpCircle className="h-5 w-5 mr-3" />
          Bantuan & FAQ
        </Button>
        
        <Button variant="outline" className="w-full justify-start h-12">
          <Heart className="h-5 w-5 mr-3" />
          Beri Rating & Ulasan
        </Button>
        
        <Button variant="outline" className="w-full justify-start h-12">
          <Shield className="h-5 w-5 mr-3" />
          Kebijakan Privasi
        </Button>
      </div>

      {/* Logout */}
      <Card className="shadow-sm border-red-200 bg-red-50 dark:bg-red-950 dark:border-red-800">
        <CardContent className="p-4">
          <Button 
            variant="ghost" 
            className="w-full justify-start text-red-600 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900"
            onClick={onLogout}
          >
            <LogOut className="h-5 w-5 mr-3" />
            Keluar dari Akun
          </Button>
        </CardContent>
      </Card>

      {/* App Info */}
      <div className="text-center text-xs text-muted-foreground py-4">
        <p>GiziSehat v1.0.0</p>
        <p className="mt-1">Mendukung SDG 3: Kesehatan & Kesejahteraan</p>
      </div>
    </div>
  );
}