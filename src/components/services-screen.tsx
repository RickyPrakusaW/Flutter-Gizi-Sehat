import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { 
  MapPin, 
  Phone, 
  Clock, 
  Navigation,
  Calendar,
  Heart,
  Stethoscope,
  Users
} from 'lucide-react';

export function ServicesScreen() {
  const nearbyServices = [
    {
      id: 1,
      name: 'Puskesmas Sehat Mandiri',
      type: 'Puskesmas',
      distance: '1.2 km',
      address: 'Jl. Kesehatan No. 123, Jakarta Selatan',
      phone: '021-1234567',
      hours: '08:00 - 16:00',
      services: ['Gizi', 'Imunisasi', 'KIA'],
      status: 'Buka'
    },
    {
      id: 2,
      name: 'Posyandu Melati 01',
      type: 'Posyandu',
      distance: '0.8 km',
      address: 'RW 01, Kelurahan Sehat, Jakarta Selatan',
      phone: '0812-3456789',
      hours: '09:00 - 12:00',
      services: ['Timbang', 'Imunisasi', 'Konseling'],
      status: 'Jadwal',
      nextSchedule: 'Minggu, 28 Jan 2024'
    },
    {
      id: 3,
      name: 'Posyandu Mawar 02',
      type: 'Posyandu',
      distance: '1.5 km',
      address: 'RW 02, Kelurahan Sehat, Jakarta Selatan',
      phone: '0813-7890123',
      hours: '08:30 - 11:30',
      services: ['Timbang', 'Penyuluhan', 'MPASI'],
      status: 'Jadwal',
      nextSchedule: 'Rabu, 31 Jan 2024'
    }
  ];

  const upcomingSchedules = [
    {
      date: '28 Jan 2024',
      day: 'Minggu',
      service: 'Posyandu Melati 01',
      activity: 'Penimbangan & Imunisasi',
      time: '09:00 - 12:00'
    },
    {
      date: '31 Jan 2024',
      day: 'Rabu',
      service: 'Posyandu Mawar 02',
      activity: 'Penyuluhan MPASI',
      time: '08:30 - 11:30'
    }
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'Buka':
        return 'bg-green-100 text-green-800';
      case 'Jadwal':
        return 'bg-blue-100 text-blue-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  const getTypeIcon = (type: string) => {
    return type === 'Puskesmas' ? Stethoscope : Users;
  };

  return (
    <div className="pb-20 px-4 pt-6 space-y-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-6">
        <h1 className="text-2xl font-semibold text-foreground mb-1">Layanan Kesehatan</h1>
        <p className="text-muted-foreground">Puskesmas & Posyandu Terdekat</p>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3 mb-6">
        <Button variant="outline" className="h-12">
          <MapPin className="h-4 w-4 mr-2" />
          Cari Terdekat
        </Button>
        <Button variant="outline" className="h-12">
          <Calendar className="h-4 w-4 mr-2" />
          Jadwal Layanan
        </Button>
      </div>

      {/* Upcoming Schedules */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Calendar className="h-5 w-5" />
            <span>Jadwal Mendatang</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {upcomingSchedules.map((schedule, index) => (
            <div key={index} className="p-3 bg-primary/5 rounded-lg border border-primary/20">
              <div className="flex justify-between items-start mb-2">
                <div>
                  <p className="font-medium text-sm">{schedule.activity}</p>
                  <p className="text-sm text-muted-foreground">{schedule.service}</p>
                </div>
                <Badge variant="secondary" className="text-xs">
                  {schedule.day}
                </Badge>
              </div>
              <div className="flex justify-between text-xs text-muted-foreground">
                <span>{schedule.date}</span>
                <span>{schedule.time}</span>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Nearby Services */}
      <div className="space-y-4">
        <h2 className="text-lg font-medium">Layanan Terdekat</h2>
        {nearbyServices.map((service) => {
          const TypeIcon = getTypeIcon(service.type);
          
          return (
            <Card key={service.id} className="shadow-sm">
              <CardContent className="p-4 space-y-4">
                {/* Header */}
                <div className="flex items-start justify-between">
                  <div className="flex items-start space-x-3">
                    <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center">
                      <TypeIcon className="h-5 w-5 text-primary" />
                    </div>
                    <div className="flex-1">
                      <h3 className="font-medium">{service.name}</h3>
                      <p className="text-sm text-muted-foreground">{service.type}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <Badge className={getStatusColor(service.status)}>
                      {service.status}
                    </Badge>
                    <p className="text-xs text-muted-foreground mt-1">
                      {service.distance}
                    </p>
                  </div>
                </div>

                {/* Address & Contact */}
                <div className="space-y-2">
                  <div className="flex items-start space-x-2">
                    <MapPin className="h-4 w-4 text-muted-foreground mt-0.5 flex-shrink-0" />
                    <p className="text-sm text-muted-foreground">{service.address}</p>
                  </div>
                  
                  <div className="flex items-center space-x-2">
                    <Phone className="h-4 w-4 text-muted-foreground" />
                    <p className="text-sm text-muted-foreground">{service.phone}</p>
                  </div>
                  
                  <div className="flex items-center space-x-2">
                    <Clock className="h-4 w-4 text-muted-foreground" />
                    <p className="text-sm text-muted-foreground">{service.hours}</p>
                  </div>

                  {service.nextSchedule && (
                    <div className="flex items-center space-x-2">
                      <Calendar className="h-4 w-4 text-muted-foreground" />
                      <p className="text-sm text-muted-foreground">
                        Jadwal: {service.nextSchedule}
                      </p>
                    </div>
                  )}
                </div>

                {/* Services */}
                <div className="space-y-2">
                  <p className="text-sm font-medium">Layanan Tersedia:</p>
                  <div className="flex flex-wrap gap-1">
                    {service.services.map((serviceItem, index) => (
                      <Badge key={index} variant="secondary" className="text-xs">
                        {serviceItem}
                      </Badge>
                    ))}
                  </div>
                </div>

                {/* Actions */}
                <div className="flex space-x-2 pt-2">
                  <Button size="sm" variant="outline" className="flex-1">
                    <Phone className="h-4 w-4 mr-2" />
                    Hubungi
                  </Button>
                  <Button size="sm" variant="outline" className="flex-1">
                    <Navigation className="h-4 w-4 mr-2" />
                    Rute
                  </Button>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Emergency Contact */}
      <Card className="shadow-sm border-red-200 bg-red-50">
        <CardContent className="p-4">
          <div className="flex items-center space-x-3">
            <div className="h-10 w-10 rounded-full bg-red-100 flex items-center justify-center">
              <Heart className="h-5 w-5 text-red-600" />
            </div>
            <div className="flex-1">
              <p className="font-medium text-red-900">Kontak Darurat</p>
              <p className="text-sm text-red-700">Puskesmas 24 jam: 119</p>
            </div>
            <Button size="sm" variant="destructive">
              Hubungi
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}