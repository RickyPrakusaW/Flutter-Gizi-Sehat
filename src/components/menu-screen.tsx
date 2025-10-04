import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './ui/tabs';
import { 
  UtensilsCrossed, 
  Clock, 
  DollarSign, 
  Users,
  Camera,
  Utensils,
  Baby
} from 'lucide-react';

export function MenuScreen() {
  const mealPlan = [
    {
      time: '06:00',
      meal: 'ASI/Formula',
      description: 'Pemberian ASI eksklusif',
      age: '6-8 bulan'
    },
    {
      time: '08:00',
      meal: 'Bubur Saring',
      description: 'Bubur beras + sayuran + protein',
      age: '6-8 bulan'
    },
    {
      time: '10:00',
      meal: 'ASI/Formula',
      description: 'Pemberian ASI',
      age: '6-8 bulan'
    },
    {
      time: '12:00',
      meal: 'Bubur Tim',
      description: 'Nasi tim + lauk + sayur',
      age: '6-8 bulan'
    }
  ];

  const nutritionGoals = {
    calories: { current: 520, target: 600, unit: 'kkal' },
    protein: { current: 18, target: 20, unit: 'g' },
    iron: { current: 3.2, target: 4.0, unit: 'mg' },
    zinc: { current: 2.1, target: 3.0, unit: 'mg' }
  };

  const foodSuggestions = [
    {
      name: 'Bubur Ayam Sayur',
      calories: 180,
      protein: 8,
      cost: 5000,
      ingredients: ['Beras', 'Ayam', 'Wortel', 'Bayam']
    },
    {
      name: 'Puree Pisang Alpukat',
      calories: 120,
      protein: 2,
      cost: 3000,
      ingredients: ['Pisang', 'Alpukat', 'ASI']
    },
    {
      name: 'Telur Kukus Tahu',
      calories: 95,
      protein: 9,
      cost: 4000,
      ingredients: ['Telur', 'Tahu', 'Daun bawang']
    }
  ];

  return (
    <div className="pb-20 px-4 pt-6 space-y-6 max-w-md mx-auto">
      {/* Header */}
      <div className="text-center mb-6">
        <h1 className="text-2xl font-semibold text-foreground mb-1">Perencanaan Menu</h1>
        <p className="text-muted-foreground">1000 Hari Pertama Kehidupan</p>
      </div>

      {/* Age Selection */}
      <Card className="shadow-sm">
        <CardContent className="p-4">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center space-x-2">
              <Baby className="h-5 w-5 text-primary" />
              <span className="font-medium">Sari - 8 bulan</span>
            </div>
            <Badge variant="secondary">MPASI</Badge>
          </div>
          <p className="text-sm text-muted-foreground">
            Periode pengenalan makanan pendamping ASI
          </p>
        </CardContent>
      </Card>

      {/* Nutrition Progress */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Utensils className="h-5 w-5" />
            <span>Target Gizi Hari Ini</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          {Object.entries(nutritionGoals).map(([key, goal]) => (
            <div key={key} className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="capitalize">{key === 'calories' ? 'Kalori' : key === 'protein' ? 'Protein' : key === 'iron' ? 'Zat Besi' : 'Seng'}</span>
                <span>{goal.current}/{goal.target} {goal.unit}</span>
              </div>
              <div className="w-full bg-muted rounded-full h-2">
                <div 
                  className="bg-primary h-2 rounded-full transition-all duration-300" 
                  style={{ width: `${Math.min((goal.current / goal.target) * 100, 100)}%` }}
                />
              </div>
            </div>
          ))}
          
          <div className="mt-4 p-3 bg-accent/10 rounded-lg">
            <p className="text-sm font-medium text-accent-foreground">
              Perlu tambahan: +80 kkal, +2g protein
            </p>
            <p className="text-xs text-muted-foreground mt-1">
              Coba bubur ayam atau telur kukus
            </p>
          </div>
        </CardContent>
      </Card>

      {/* Today's Meal Plan */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <Clock className="h-5 w-5" />
            <span>Jadwal Makan Hari Ini</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {mealPlan.map((meal, index) => (
            <div key={index} className="flex items-start space-x-3 p-3 rounded-lg bg-muted/30">
              <div className="text-center min-w-[60px]">
                <p className="text-sm font-medium">{meal.time}</p>
                <p className="text-xs text-muted-foreground">WIB</p>
              </div>
              <div className="flex-1">
                <h4 className="font-medium text-sm">{meal.meal}</h4>
                <p className="text-xs text-muted-foreground">{meal.description}</p>
              </div>
              <Button size="sm" variant="ghost" className="h-8 w-8 p-0">
                <Camera className="h-4 w-4" />
              </Button>
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Food Suggestions */}
      <Card className="shadow-sm">
        <CardHeader>
          <CardTitle className="flex items-center space-x-2">
            <UtensilsCrossed className="h-5 w-5" />
            <span>Rekomendasi Menu</span>
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          {foodSuggestions.map((food, index) => (
            <div key={index} className="p-4 border border-border rounded-lg hover:bg-muted/20 transition-colors">
              <div className="flex justify-between items-start mb-2">
                <h4 className="font-medium">{food.name}</h4>
                <Badge variant="outline" className="text-xs">
                  Rp {food.cost.toLocaleString()}
                </Badge>
              </div>
              
              <div className="flex justify-between text-sm text-muted-foreground mb-3">
                <span>{food.calories} kkal</span>
                <span>{food.protein}g protein</span>
              </div>
              
              <div className="flex flex-wrap gap-1 mb-3">
                {food.ingredients.map((ingredient, i) => (
                  <Badge key={i} variant="secondary" className="text-xs">
                    {ingredient}
                  </Badge>
                ))}
              </div>
              
              <Button size="sm" className="w-full">
                Tambah ke Menu
              </Button>
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 gap-3">
        <Button className="h-12" variant="outline">
          <DollarSign className="h-4 w-4 mr-2" />
          Hitung Biaya
        </Button>
        <Button className="h-12" variant="outline">
          <Users className="h-4 w-4 mr-2" />
          Food Swap
        </Button>
      </div>
    </div>
  );
}