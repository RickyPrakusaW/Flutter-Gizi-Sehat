import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './ui/tabs';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Area, AreaChart } from 'recharts';
import { Baby, TrendingUp, Calendar, Ruler } from 'lucide-react';

export function GrowthScreen() {
  const children = [
    { id: 1, name: 'Sari', age: '8 bulan', active: true },
    { id: 2, name: 'Budi', age: '2 tahun 4 bulan', active: false }
  ];

  const weightData = [
    { age: '0', weight: 3.2, percentile: 50 },
    { age: '2', weight: 4.8, percentile: 45 },
    { age: '4', weight: 6.2, percentile: 50 },
    { age: '6', weight: 7.1, percentile: 52 },
    { age: '8', weight: 8.0, percentile: 55 }
  ];

  const heightData = [
    { age: '0', height: 48, percentile: 50 },
    { age: '2', height: 56, percentile: 48 },
    { age: '4', height: 62, percentile: 50 },
    { age: '6', height: 67, percentile: 52 },
    { age: '8', height: 70, percentile: 55 }
  ];

  const latestMeasurement = {
    date: '2024-01-15',
    weight: '8.0 kg',
    height: '70 cm',
    muac: '13.5 cm',
    status: 'Normal',
    statusColor: 'bg-green-100 text-green-800'
  };

  return (
    <div className="pb-20 px-4 pt-6 space-y-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-6">
        <h1 className="text-2xl font-semibold text-foreground mb-1">Pemantauan Tumbuh Kembang</h1>
        <p className="text-muted-foreground">Kurva Pertumbuhan WHO</p>
      </div>

      {/* Child Selection */}
      <Card className="shadow-sm">
        <CardContent className="p-4">
          <div className="flex justify-between items-center mb-4">
            <h2 className="font-medium">Pilih Anak</h2>
          </div>
          <div className="space-y-2">
            {children.map((child) => (
              <div 
                key={child.id} 
                className={`p-3 rounded-lg border cursor-pointer transition-colors ${
                  child.active 
                    ? 'border-primary bg-primary/5' 
                    : 'border-border hover:bg-muted/50'
                }`}
              >
                <div className="flex items-center space-x-3">
                  <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center">
                    <Baby className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="font-medium">{child.name}</p>
                    <p className="text-sm text-muted-foreground">{child.age}</p>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Latest Measurement */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Ruler className="h-5 w-5" />
            <span>Pengukuran Terakhir</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex justify-between items-center">
            <span className="text-sm text-muted-foreground">Tanggal</span>
            <span className="font-medium">{latestMeasurement.date}</span>
          </div>
          
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center p-3 bg-muted/30 rounded-lg">
              <p className="text-xs text-muted-foreground mb-1">Berat</p>
              <p className="font-semibold">{latestMeasurement.weight}</p>
            </div>
            <div className="text-center p-3 bg-muted/30 rounded-lg">
              <p className="text-xs text-muted-foreground mb-1">Tinggi</p>
              <p className="font-semibold">{latestMeasurement.height}</p>
            </div>
            <div className="text-center p-3 bg-muted/30 rounded-lg">
              <p className="text-xs text-muted-foreground mb-1">MUAC</p>
              <p className="font-semibold">{latestMeasurement.muac}</p>
            </div>
          </div>
          
          <div className="flex justify-between items-center pt-2 border-t">
            <span className="text-sm text-muted-foreground">Status Gizi</span>
            <Badge className={latestMeasurement.statusColor}>
              {latestMeasurement.status}
            </Badge>
          </div>
        </CardContent>
      </Card>

      {/* Growth Charts */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <TrendingUp className="h-5 w-5" />
            <span>Kurva Pertumbuhan</span>
          </CardTitle>
        </CardHeader>
        <CardContent>
          <Tabs defaultValue="weight" className="w-full">
            <TabsList className="grid w-full grid-cols-2">
              <TabsTrigger value="weight">Berat Badan</TabsTrigger>
              <TabsTrigger value="height">Tinggi Badan</TabsTrigger>
            </TabsList>
            
            <TabsContent value="weight" className="mt-4">
              <div className="h-48">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={weightData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis 
                      dataKey="age" 
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12 }}
                    />
                    <YAxis 
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12 }}
                    />
                    <Tooltip 
                      contentStyle={{ 
                        background: 'white', 
                        border: '1px solid #e2e8f0',
                        borderRadius: '8px',
                        fontSize: '12px'
                      }}
                      formatter={(value) => [`${value} kg`, 'Berat']}
                      labelFormatter={(label) => `Usia: ${label} bulan`}
                    />
                    <Area 
                      type="monotone" 
                      dataKey="weight" 
                      stroke="#4CAF50" 
                      strokeWidth={2}
                      fill="#4CAF50"
                      fillOpacity={0.1}
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
              <p className="text-xs text-muted-foreground mt-2">
                Grafik berat badan menurut usia (0-59 bulan)
              </p>
            </TabsContent>
            
            <TabsContent value="height" className="mt-4">
              <div className="h-48">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={heightData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis 
                      dataKey="age" 
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12 }}
                    />
                    <YAxis 
                      axisLine={false}
                      tickLine={false}
                      tick={{ fontSize: 12 }}
                    />
                    <Tooltip 
                      contentStyle={{ 
                        background: 'white', 
                        border: '1px solid #e2e8f0',
                        borderRadius: '8px',
                        fontSize: '12px'
                      }}
                      formatter={(value) => [`${value} cm`, 'Tinggi']}
                      labelFormatter={(label) => `Usia: ${label} bulan`}
                    />
                    <Area 
                      type="monotone" 
                      dataKey="height" 
                      stroke="#FFC107" 
                      strokeWidth={2}
                      fill="#FFC107"
                      fillOpacity={0.1}
                    />
                  </AreaChart>
                </ResponsiveContainer>
              </div>
              <p className="text-xs text-muted-foreground mt-2">
                Grafik tinggi badan menurut usia (0-59 bulan)
              </p>
            </TabsContent>
          </Tabs>
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3">
        <Button className="h-12" variant="outline">
          <Calendar className="h-4 w-4 mr-2" />
          Riwayat
        </Button>
        <Button className="h-12" variant="outline">
          <TrendingUp className="h-4 w-4 mr-2" />
          Analisis
        </Button>
      </div>
    </div>
  );
}