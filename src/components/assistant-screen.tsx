import { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { ScrollArea } from './ui/scroll-area';
import { 
  Bot, 
  Send, 
  Camera,
  Utensils,
  Baby,
  AlertTriangle,
  MessageCircle
} from 'lucide-react';

interface Message {
  id: string;
  type: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

export function AssistantScreen() {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: '1',
      type: 'assistant',
      content: 'Halo! Saya asisten gizi virtual GiziSehat. Saya siap membantu Anda dengan pertanyaan seputar gizi dan tumbuh kembang anak. Ada yang bisa saya bantu hari ini?',
      timestamp: new Date()
    }
  ]);
  
  const [inputMessage, setInputMessage] = useState('');

  const quickChips = [
    { id: 'mpasi', text: 'MPASI 9-11 bulan', icon: Baby },
    { id: 'protein', text: 'Cek asupan protein', icon: Utensils },
    { id: 'picky', text: 'Anak susah makan sayur', icon: AlertTriangle },
    { id: 'budget', text: 'Menu sehat murah', icon: MessageCircle }
  ];

  const handleSendMessage = () => {
    if (!inputMessage.trim()) return;

    const newUserMessage: Message = {
      id: Date.now().toString(),
      type: 'user',
      content: inputMessage,
      timestamp: new Date()
    };

    setMessages(prev => [...prev, newUserMessage]);

    // Simulate AI response
    setTimeout(() => {
      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        type: 'assistant',
        content: getAIResponse(inputMessage),
        timestamp: new Date()
      };
      setMessages(prev => [...prev, aiResponse]);
    }, 1000);

    setInputMessage('');
  };

  const handleQuickChip = (chipId: string, chipText: string) => {
    setInputMessage(chipText);
  };

  const getAIResponse = (userMessage: string): string => {
    const message = userMessage.toLowerCase();
    
    if (message.includes('mpasi') || message.includes('9-11')) {
      return 'Untuk MPASI usia 9-11 bulan:\n\n• Tekstur: makanan cincang halus\n• Frekuensi: 3x makan utama + 2x selingan\n• Porsi: 125-250ml per makan\n• Menu: nasi tim + lauk (ayam/ikan/telur) + sayur + buah\n\nContoh menu: nasi tim ayam wortel, pisang kukus, biskuit bayi.\n\n⚠️ Konsultasi ke dokter jika ada alergi atau masalah makan.';
    }
    
    if (message.includes('protein')) {
      return 'Kebutuhan protein harian untuk anak:\n\n• 6-8 bulan: 18-20g\n• 9-11 bulan: 20-25g\n• 12-23 bulan: 25-30g\n\nSumber protein baik:\n• Telur (6g/butir)\n• Ikan (15g/50g)\n• Ayam (20g/50g)\n• Tempe (8g/50g)\n• Tahu (5g/50g)\n\nBerdasarkan data Sari hari ini: 18g dari target 20g. Coba tambah 1 potong tempe goreng.';
    }
    
    if (message.includes('sayur') || message.includes('susah')) {
      return 'Tips mengatasi anak susah makan sayur:\n\n1. Campurkan sayur dalam makanan favorit\n2. Buat bentuk menarik (wortel bintang)\n3. Libatkan anak dalam memasak\n4. Berikan contoh orang tua makan sayur\n5. Jangan paksa, tawarkan berulang kali\n6. Variasi warna sayuran\n\nResep mudah: nugget sayur, pancake bayam, sup ayam sayuran.';
    }
    
    if (message.includes('murah') || message.includes('budget')) {
      return 'Menu sehat hemat untuk balita:\n\n💰 Budget Rp 15.000/hari:\n• Pagi: Bubur telur bayam (Rp 4.000)\n• Siang: Nasi + ikan asin + tumis kangkung (Rp 6.000)\n• Sore: Pisang + tempe goreng (Rp 3.000)\n• Malam: Bubur kacang hijau (Rp 2.000)\n\nTips hemat:\n✓ Beli sayur di pasar tradisional\n✓ Pakai protein lokal (tempe, tahu, telur)\n✓ Masak sendiri\n✓ Beli dalam jumlah banyak';
    }
    
    return 'Terima kasih atas pertanyaannya! Untuk informasi yang lebih akurat dan personal, saya merekomendasikan untuk berkonsultasi dengan dokter anak atau ahli gizi. Sementara itu, pastikan anak mendapat ASI/susu formula, makanan bergizi seimbang, dan pemantauan tumbuh kembang rutin.\n\n📞 Hubungi Puskesmas terdekat untuk konsultasi langsung.';
  };

  return (
    <div className="flex flex-col h-screen max-w-md mx-auto bg-background">
      {/* Header */}
      <div className="px-4 pt-6 pb-4 border-b">
        <div className="flex items-center space-x-3">
          <div className="h-10 w-10 rounded-full bg-primary/10 flex items-center justify-center">
            <Bot className="h-6 w-6 text-primary" />
          </div>
          <div>
            <h1 className="text-xl font-semibold">Asisten Gizi AI</h1>
            <p className="text-sm text-muted-foreground">Dokter Gizi Virtual</p>
          </div>
        </div>
      </div>

      {/* Quick Action Chips */}
      <div className="px-4 py-3 border-b">
        <p className="text-sm font-medium mb-3">Pertanyaan cepat:</p>
        <div className="flex flex-wrap gap-2">
          {quickChips.map((chip) => {
            const Icon = chip.icon;
            return (
              <Button
                key={chip.id}
                variant="outline"
                size="sm"
                className="text-xs h-8"
                onClick={() => handleQuickChip(chip.id, chip.text)}
              >
                <Icon className="h-3 w-3 mr-1" />
                {chip.text}
              </Button>
            );
          })}
        </div>
      </div>

      {/* Chat Messages */}
      <ScrollArea className="flex-1 px-4 py-4">
        <div className="space-y-4 pb-20">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex ${message.type === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div
                className={`max-w-[80%] rounded-lg p-3 ${
                  message.type === 'user'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-muted text-foreground'
                }`}
              >
                {message.type === 'assistant' && (
                  <div className="flex items-center space-x-2 mb-2">
                    <Bot className="h-4 w-4" />
                    <span className="text-xs font-medium">Asisten Gizi</span>
                  </div>
                )}
                <p className="text-sm whitespace-pre-line">{message.content}</p>
                <p className="text-xs opacity-70 mt-2">
                  {message.timestamp.toLocaleTimeString('id-ID', { 
                    hour: '2-digit', 
                    minute: '2-digit' 
                  })}
                </p>
              </div>
            </div>
          ))}
        </div>
      </ScrollArea>

      {/* Input Area */}
      <div className="p-4 border-t bg-background">
        <div className="flex space-x-2">
          <Button size="icon" variant="outline">
            <Camera className="h-4 w-4" />
          </Button>
          <Input
            value={inputMessage}
            onChange={(e) => setInputMessage(e.target.value)}
            placeholder="Tanya tentang gizi anak..."
            className="flex-1"
            onKeyDown={(e) => {
              if (e.key === 'Enter') {
                handleSendMessage();
              }
            }}
          />
          <Button onClick={handleSendMessage} size="icon">
            <Send className="h-4 w-4" />
          </Button>
        </div>
        
        <div className="mt-3 text-center">
          <p className="text-xs text-muted-foreground">
            ⚠️ Ini bukan pengganti konsultasi medis. Selalu konsultasi dengan dokter untuk diagnosis dan pengobatan.
          </p>
        </div>
      </div>
    </div>
  );
}