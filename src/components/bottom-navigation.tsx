import { Home, TrendingUp, UtensilsCrossed, Bot, User } from 'lucide-react';

interface BottomNavigationProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

export function BottomNavigation({ activeTab, onTabChange }: BottomNavigationProps) {
  const tabs = [
    { id: 'home', label: 'Beranda', icon: Home },
    { id: 'growth', label: 'Tumbuh', icon: TrendingUp },
    { id: 'menu', label: 'Menu', icon: UtensilsCrossed },
    { id: 'assistant', label: 'Asisten', icon: Bot },
    { id: 'profile', label: 'Profil', icon: User }
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-border z-50">
      <div className="flex justify-around items-center h-16 max-w-md mx-auto px-2">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center justify-center min-w-0 flex-1 py-2 px-1 transition-colors ${
                isActive 
                  ? 'text-primary' 
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              <Icon className={`h-5 w-5 mb-1 ${isActive ? 'text-primary' : ''}`} />
              <span className={`text-xs truncate ${isActive ? 'text-primary font-medium' : ''}`}>
                {tab.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}