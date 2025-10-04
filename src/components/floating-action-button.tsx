import { Plus, Camera, Scale } from 'lucide-react';
import { Button } from './ui/button';

interface FABProps {
  activeTab: string;
  onAddMeasurement: () => void;
  onTakePhoto: () => void;
}

export function FloatingActionButton({ activeTab, onAddMeasurement, onTakePhoto }: FABProps) {
  const handleClick = () => {
    if (activeTab === 'growth') {
      onAddMeasurement();
    } else {
      onTakePhoto();
    }
  };

  return (
    <Button
      onClick={handleClick}
      className="fixed bottom-20 right-4 h-14 w-14 rounded-full bg-primary hover:bg-primary/90 shadow-lg z-40"
      size="icon"
    >
      {activeTab === 'growth' ? (
        <Scale className="h-6 w-6 text-white" />
      ) : (
        <Camera className="h-6 w-6 text-white" />
      )}
    </Button>
  );
}