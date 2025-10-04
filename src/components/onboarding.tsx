import { useState } from 'react';
import { Button } from './ui/button';
import { Card, CardContent } from './ui/card';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface OnboardingProps {
  onComplete: () => void;
}

export function Onboarding({ onComplete }: OnboardingProps) {
  const [currentSlide, setCurrentSlide] = useState(0);

  const slides = [
    {
      id: 1,
      title: "Cegah Stunting Sejak Dini",
      subtitle: "Pantau tumbuh kembang anak dengan mudah",
      description: "Gunakan kurva pertumbuhan WHO untuk memantau berat dan tinggi badan anak secara berkala. Deteksi dini risiko stunting untuk masa depan yang lebih sehat.",
      image: "https://images.unsplash.com/photo-1594643781026-abcb610d394f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaGlsZCUyMGdyb3d0aCUyMG1lYXN1cmVtZW50JTIwc2NhbGUlMjBkb2N0b3J8ZW58MXx8fHwxNzU5MTQwOTIyfDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
      color: "bg-green-50 dark:bg-green-950"
    },
    {
      id: 2,
      title: "Deteksi Gizi dari Foto Makanan",
      subtitle: "AI pintar untuk analisis nutrisi",
      description: "Ambil foto makanan dan dapatkan analisis kandungan gizi secara otomatis. Teknologi AI membantu menghitung kalori, protein, dan nutrisi penting lainnya.",
      image: "https://images.unsplash.com/photo-1758523419884-a1ab1c98b434?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb29kJTIwcGhvdG9ncmFwaHklMjBjYW1lcmElMjBwaG9uZSUyMG51dHJpdGlvbnxlbnwxfHx8fDE3NTkxNDA5MjZ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
      color: "bg-yellow-50 dark:bg-yellow-950"
    },
    {
      id: 3,
      title: "Asisten Gizi dan Saran Menu",
      subtitle: "Konsultasi 24/7 dengan AI",
      description: "Dapatkan saran menu sehat sesuai usia anak, konsultasi gizi, dan rekomendasi makanan lokal yang terjangkau. Asisten AI siap membantu kapan saja.",
      image: "https://images.unsplash.com/photo-1682941664177-7920d0e59418?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmYW1pbHklMjBoZWFsdGglMjBhc3Npc3RhbnQlMjBjaGF0JTIwYm90fGVufDF8fHx8MTc1OTE0MDkyOXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
      color: "bg-blue-50 dark:bg-blue-950"
    }
  ];

  const nextSlide = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      onComplete();
    }
  };

  const prevSlide = () => {
    if (currentSlide > 0) {
      setCurrentSlide(currentSlide - 1);
    }
  };

  const goToSlide = (index: number) => {
    setCurrentSlide(index);
  };

  const currentSlideData = slides[currentSlide];

  return (
    <div className={`min-h-screen ${currentSlideData.color} transition-colors duration-500 flex flex-col`}>
      <div className="flex-1 flex flex-col justify-center items-center px-6 py-12">
        <div className="w-full max-w-sm space-y-8">
          {/* Image */}
          <div className="relative h-80 w-full overflow-hidden rounded-3xl shadow-lg">
            <ImageWithFallback
              src={currentSlideData.image}
              alt={currentSlideData.title}
              className="h-full w-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent" />
          </div>

          {/* Content */}
          <div className="text-center space-y-4">
            <div className="space-y-2">
              <h1 className="text-2xl font-semibold text-foreground">
                {currentSlideData.title}
              </h1>
              <p className="text-lg text-primary font-medium">
                {currentSlideData.subtitle}
              </p>
            </div>
            <p className="text-muted-foreground leading-relaxed">
              {currentSlideData.description}
            </p>
          </div>

          {/* Progress Indicators */}
          <div className="flex justify-center space-x-2">
            {slides.map((_, index) => (
              <button
                key={index}
                onClick={() => goToSlide(index)}
                className={`h-2 rounded-full transition-all duration-300 ${
                  index === currentSlide 
                    ? 'w-8 bg-primary' 
                    : 'w-2 bg-primary/30'
                }`}
              />
            ))}
          </div>
        </div>
      </div>

      {/* Navigation */}
      <div className="px-6 pb-8">
        <div className="flex justify-between items-center">
          <Button
            variant="ghost"
            onClick={prevSlide}
            disabled={currentSlide === 0}
            className="h-12 w-12 rounded-full"
          >
            <ChevronLeft className="h-5 w-5" />
          </Button>

          <div className="flex space-x-3">
            {currentSlide < slides.length - 1 ? (
              <>
                <Button variant="ghost" onClick={onComplete}>
                  Lewati
                </Button>
                <Button onClick={nextSlide} className="px-8">
                  Lanjut
                </Button>
              </>
            ) : (
              <Button onClick={onComplete} className="px-8">
                Mulai Sekarang
              </Button>
            )}
          </div>

          <Button
            variant="ghost"
            onClick={nextSlide}
            disabled={currentSlide === slides.length - 1}
            className="h-12 w-12 rounded-full"
          >
            <ChevronRight className="h-5 w-5" />
          </Button>
        </div>
      </div>
    </div>
  );
}