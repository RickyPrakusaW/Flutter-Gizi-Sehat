import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { 
  Baby, 
  AlertTriangle, 
  Calendar,
  TrendingUp,
  Heart,
  BookOpen,
  Bot,
  UtensilsCrossed
} from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface HomeScreenProps {
  onNavigateToAssistant?: () => void;
}

export function HomeScreen({ onNavigateToAssistant }: HomeScreenProps) {
  const children = [
    {
      id: 1,
      name: 'Sari',
      age: '8 bulan',
      status: 'Normal',
      statusColor: 'bg-green-100 text-green-800',
      nextCheckup: '3 hari lagi'
    },
    {
      id: 2,
      name: 'Budi',
      age: '2 tahun 4 bulan',
      status: 'Berisiko',
      statusColor: 'bg-yellow-100 text-yellow-800',
      nextCheckup: 'Minggu depan'
    }
  ];

  const todayReminders = [
    { type: 'MPASI', child: 'Sari', time: '12:00', icon: UtensilsCrossed },
    { type: 'Imunisasi', child: 'Budi', time: '14:00', icon: Heart }
  ];

  return (
    <div className="pb-20 px-4 pt-6 space-y-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-6">
        <h1 className="text-2xl font-semibold text-foreground mb-1">GiziSehat</h1>
        <p className="text-muted-foreground">Asisten Gizi Keluarga</p>
      </div>

      {/* AI Assistant Card */}
      <Card 
        className="shadow-sm cursor-pointer hover:shadow-md transition-all mb-6 bg-gradient-to-r from-blue-50 to-purple-50 border-blue-200"
        onClick={onNavigateToAssistant}
      >
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <div className="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center">
                <Bot className="h-6 w-6 text-blue-600" />
              </div>
              <div>
                <h3 className="font-medium text-blue-900">Chat dengan Asisten Gizi</h3>
                <p className="text-sm text-blue-700">Konsultasi seputar nutrisi & tumbuh kembang</p>
              </div>
            </div>
            <div className="text-blue-600">
              <svg className="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Children Cards */}
      <div className="space-y-4">
        <h2 className="text-lg font-medium">Anak-anak Saya</h2>
        {children.map((child) => (
          <Card key={child.id} className="shadow-sm">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-3">
                  <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center">
                    <Baby className="h-6 w-6 text-primary" />
                  </div>
                  <div>
                    <h3 className="font-medium">{child.name}</h3>
                    <p className="text-sm text-muted-foreground">{child.age}</p>
                  </div>
                </div>
                <div className="text-right">
                  <Badge className={child.statusColor}>
                    {child.status}
                  </Badge>
                  <p className="text-xs text-muted-foreground mt-1">
                    Cek: {child.nextCheckup}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
        
        <Button variant="outline" className="w-full">
          <Baby className="h-4 w-4 mr-2" />
          Tambah Anak
        </Button>
      </div>

      {/* Quick Actions */}
      <div className="space-y-4">
        <h2 className="text-lg font-medium">Aksi Cepat</h2>
        <div className="grid grid-cols-2 gap-3">
          <Card className="shadow-sm cursor-pointer hover:bg-muted/50 transition-colors">
            <CardContent className="p-4 text-center">
              <TrendingUp className="h-8 w-8 text-primary mx-auto mb-2" />
              <p className="text-sm font-medium">Cek Pertumbuhan</p>
            </CardContent>
          </Card>
          
          <Card className="shadow-sm cursor-pointer hover:bg-muted/50 transition-colors">
            <CardContent className="p-4 text-center">
              <AlertTriangle className="h-8 w-8 text-accent mx-auto mb-2" />
              <p className="text-sm font-medium">Skrining Risiko</p>
            </CardContent>
          </Card>
          
          <Card className="shadow-sm cursor-pointer hover:bg-muted/50 transition-colors">
            <CardContent className="p-4 text-center">
              <Calendar className="h-8 w-8 text-primary mx-auto mb-2" />
              <p className="text-sm font-medium">Jadwal Posyandu</p>
            </CardContent>
          </Card>
          
          <Card 
            className="shadow-sm cursor-pointer hover:bg-muted/50 transition-colors"
            onClick={onNavigateToAssistant}
          >
            <CardContent className="p-4 text-center">
              <Bot className="h-8 w-8 text-blue-500 mx-auto mb-2" />
              <p className="text-sm font-medium">Chat Asisten</p>
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Today's Reminders */}
      <div className="space-y-4">
        <h2 className="text-lg font-medium">Pengingat Hari Ini</h2>
        <Card className="shadow-sm">
          <CardContent className="p-4 space-y-3">
            <div className="flex items-center justify-between p-3 bg-accent/10 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="h-8 w-8 rounded-full bg-accent/20 flex items-center justify-center">
                  <UtensilsCrossed className="h-4 w-4 text-accent-foreground" />
                </div>
                <div>
                  <p className="font-medium text-sm">MPASI Sari</p>
                  <p className="text-xs text-muted-foreground">12:00 WIB</p>
                </div>
              </div>
              <Button size="sm" variant="outline">
                Selesai
              </Button>
            </div>
            
            <div className="flex items-center justify-between p-3 bg-primary/5 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="h-8 w-8 rounded-full bg-primary/20 flex items-center justify-center">
                  <Heart className="h-4 w-4 text-primary" />
                </div>
                <div>
                  <p className="font-medium text-sm">Imunisasi Budi</p>
                  <p className="text-xs text-muted-foreground">14:00 WIB</p>
                </div>
              </div>
              <Button size="sm" variant="outline">
                Selesai
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

