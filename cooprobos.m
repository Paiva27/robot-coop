function cooprobos
%usando t�cnicas do codigo robotica_base
%fa�a o transporte de dois objetos at� o alvo
%com os seguintes robos:
%Robo � criado
Robo=Criar_Robo;
Robo=Criar_Robo(Robo,[10 10],2,10);
Robo2=Criar_Robo;
Robo2=Criar_Robo(Robo2,[0 0],1,10);

 
 %Objeto para ser transportado - a terceira posi��o � o angulo do objeto
 Objeto.pos=[120 100 0];
 Objeto.raio=10;
 Objeto.vel=0.1;
 Objeto2.pos=[100 300 0];
 Objeto2.raio=10;
 Objeto2.vel=0.1;
 %alvo para onde o objeto deve ser deslocado 
 Alvo(2).pos=[300 350 0];
 Alvo(2).raio=0;
 Alvo(1).pos=[300 100 0];
 Alvo(1).raio=0;
 %obstaculos
 Obstaculo(1).pos=[300 200 0];
 Obstaculo(1).raio=10;
 Obstaculo(2).pos=[100 100 0];
 Obstaculo(2).raio=10;
 Obstaculo(3).pos=[200 300 0];
 Obstaculo(3).raio=10;
 
 
 
 %variavel para contar as itera��es 
 %pode ser utilizada para controlar o numero de exibi��es
 %no plot (que pode ser muito lento)
 n=0;
 fim = 1;
 %Depois que acabar o programa o timer funciona pra não fechar abruptamente
 timer = 1000;
while(fim)
n=n+1;

%colis�o em todos os objetos
 %Objeto se afasta dos obstaculos
  Objeto=Repulsao(Objeto,Obstaculo(1),1000);
  Objeto2=Repulsao(Objeto2,Obstaculo(1),1000);
 for i=1:2
 %Robo se afasta dos obstaculos e dos objetos 
  Robo(i)=Repulsao(Robo(i),Obstaculo(1),1000);
  Robo(i)=Repulsao(Robo(i),Obstaculo(2),1000);
  Robo(i)=Repulsao(Robo(i),Objeto,10);
  Robo2(i)=Repulsao(Robo2(i),Obstaculo(1),1000);
  Robo2(i)=Repulsao(Robo2(i),Obstaculo(2),1000);
  Robo2(i)=Repulsao(Robo2(i),Obstaculo(3),1000);
  Robo2(i)=Repulsao(Robo2(i),Objeto2,1);
  %objeto tambem se afasta dos robos
  Objeto=Repulsao(Objeto,Robo(i),10);
  Objeto2=Repulsao(Objeto2,Robo2(i),1);
  for j=1:2
    if i~=j
 %Robos se afastam de outros robos 
    Robo(i)=Repulsao(Robo(i),Robo(j),1000);
      Robo(j)=Repulsao(Robo(j),Robo(i),1000);
    Robo2(i)=Repulsao(Robo2(i),Robo2(j),1000);
      Robo2(j)=Repulsao(Robo2(j),Robo2(i),1000);
    end 
  end
 end
 
%Primeira parte da miss�o - Robos devem ser atraidos pelo objeto
    for i=1:2
        Robo(i)=Atracao(Robo(i),Objeto,.5);
        Robo2(i)=Atracao(Robo2(i),Objeto2,.5);
        %Se calcula a distancia entre cada robo e o objeto

        dist_obj_rob(i)=sqrt((Robo(i).pos(1)-Objeto.pos(1)).^2+ (Robo(i).pos(2)-Objeto.pos(2)).^2);
        dist_obj_rob2(i)=sqrt((Robo2(i).pos(1)-Objeto2.pos(1)).^2+ (Robo2(i).pos(2)-Objeto2.pos(2)).^2);  
          
        end

  
     %robos se distribuem em volta do objeto engaiolando-o
    if mean(dist_obj_rob)<=Robo(1).raio+Objeto.raio
        Robo(1)=Atracao(Robo(1),Robo(2),-5);
        Robo(2)=Atracao(Robo(2),Robo(1),-5);
    end

    if mean(dist_obj_rob2)<=Robo2(1).raio+Objeto2.raio
        Robo2(1)=Atracao(Robo2(1),Robo2(2),-5);
        Robo2(2)=Atracao(Robo2(2),Robo2(1),-5);
    end
    
    %funcoes para fazer o engaiolamento corretamente
  
    a= (Robo(1).pos(1)-Robo(2).pos(1)).^2+(Robo(1).pos(2)-Robo(2).pos(2)).^2;
    a2= (Robo2(1).pos(1)-Robo2(2).pos(1)).^2+(Robo2(1).pos(2)-Robo2(2).pos(2)).^2;
 
    if ( ([sqrt(a)] > 20) && ([sqrt(a)] < 50) )
         Objeto=Atracao(Objeto(1),Alvo(1),0.5); 
    end
    
    if !( ([sqrt(a2)] >= 20) && ([sqrt(a2)] <= 50) ) 
          Robo2(1).pos(2) += 1;
          Robo2(1)=Atracao(Robo2(1),Objeto2(1),5);
        
    end

    if (  ([sqrt(a2)] > 20) && ([sqrt(a2)] < 50) ) 
         Objeto2=Atracao(Objeto2(1),Alvo(2),0.5); 
         Robo2(2)=Atracao(Robo2(2),Objeto2(1),5);
    end
    
    a= (Objeto(1).pos(1)-Alvo(1).pos(1)).^2+(Objeto(1).pos(2)-Alvo(1).pos(2)).^2;
    a2= (Objeto2(1).pos(1)-Alvo(2).pos(1)).^2+(Objeto2(1).pos(2)-Alvo(2).pos(2)).^2;
 
    if ( ([sqrt(a)] < 11) &&  ([sqrt(a2)]< 11) )
    timer -= 1;
    end
    if (timer == 0)
    fim = 0
    end

  if mod(n,10)==0
 Exibir_Arena([400 400],Robo,Robo2,Alvo,Obstaculo,Objeto,Objeto2);
  end
end
end


function Robo=Criar_Robo(Robo,pos,vel,raio)
%funcao para criar Robos
%  Robo=Criar_Robo
    Robo_novo.pos=[rand*100 rand*100 0];
    Robo_novo.vel=2;
    Robo_novo.raio=10;


 %cria Robo com dados em default
 if nargin==0 
   Robo=Robo_novo;
 elseif nargin==1 
    if isempty(Robo) 
       Robo=Robo_novo;
    else
       Robo=[Robo Robo_novo];
    end  
 elseif (nargin==2)
   Robo_novo.pos=pos;
   Robo=[Robo Robo_novo];
 elseif (nargin==3)
   Robo_novo.pos=pos;
   Robo_novo.vel=vel;
   Robo=[Robo Robo_novo];
 elseif (nargin==4)
   Robo_novo.pos=pos;
   Robo_novo.vel=vel;
   Robo_novo.raio=raio;
   Robo=[Robo Robo_novo];
 end
  
end

function Robo=Atracao(Robo,Alvo,k)
   %sensoriamento 
   %determina distancia entre alvo e Robos
   distx=Alvo.pos(1)-Robo.pos(1);
   disty=Alvo.pos(2)-Robo.pos(2);
   dist=sqrt(distx.^2+disty.^2);
    if (nargin==2)
     %aplica o grau de atracao ao alvo
      k=0.1;
    end 
   
  
   if dist < (Robo.raio + Alvo.raio)
   k=-k;
     
   end
      vx=k*distx;
      vy=k*disty;
      v=sqrt(vx^2+vy^2);
     if ~isfield(Robo,'vel')
       Robo.vel=1;
     end
     if v>Robo.vel
     %limitacao da velocidade
      vx=(Robo.vel)*(vx/v);
      vy=(Robo.vel)*(vy/v);
      v2=sqrt(vx^2+vy^2);
         %atuacao
     ant=Robo.pos;
     Robo.pos(1)=Robo.pos(1)+vx;
     Robo.pos(2)=Robo.pos(2)+vy;
     atual=Robo.pos;
     Robo.pos(3)=tan((atual(2)-ant(2))/atual(1)-ant(1));
 
     end 
      
     
 
      
end
 
function Robo=Repulsao(Robo,Obstaculo,kr)

   %sensoriamento 
   %determina distancia entre alvo e Robos
   distx=Robo.pos(1)-Obstaculo.pos(1);
   disty=Robo.pos(2)-Obstaculo.pos(2);
   dist=sqrt(distx.^2+disty.^2);
   %processamento
     if (nargin==2)
     %aplica o grau de atracao ao alvo
      kr=100;
     end 
   
   if dist^2 < (Robo.raio + Obstaculo.raio)^2
   
     
      vx=kr*distx;
      vy=kr*disty;
      v=sqrt(vx^2+vy^2);
     if ~isfield(Robo,'vel')
       Robo.vel=1;
     end
     if v>Robo.vel
     %limitacao da velocidade
      vx=(Robo.vel)*(vx/v);
      vy=(Robo.vel)*(vy/v);
      v2=sqrt(vx^2+vy^2);
     end
     
           %atuacao
     ant=Robo.pos;
     Robo.pos(1)=Robo.pos(1)+vx+randn*1e-9;
     Robo.pos(2)=Robo.pos(2)+vy+randn*1e-9;
     atual=Robo.pos;
     Robo.pos(3)=tan((atual(2)-ant(2))/atual(1)-ant(1));
     

   end 
  
   
   
end
 
function Exibir_Arena(tamanho,Robo,Robo2,Alvo,Obstaculo,Objeto,Objeto2)
 
  if  nargin>1
    vRobo=[];
    vRobo2=[];
    for i=1:length(Robo) 
     vRobo=[vRobo; Robo(i).pos(1) Robo(i).pos(2)];  
    end
    for i=1:length(Robo2) 
     vRobo2=[vRobo2; Robo2(i).pos(1) Robo2(i).pos(2)];  
    end
  end 
     
  if nargin>2
      vAlvo=[];
    for i=1:length(Alvo) 
     vAlvo=[vAlvo; Alvo(i).pos(1) Alvo(i).pos(2)];  
    end 

  end
  if  nargin>3
     vObstaculo=[];
    for i=1:length(Obstaculo)
     vObstaculo=[vObstaculo; Obstaculo(i).pos(1) Obstaculo(i).pos(2)];
    end
  end  
   if  nargin>4
     vObjeto=[];
     vObjeto2=[];
    for i=1:length(Objeto)
     vObjeto=[vObjeto; Objeto(i).pos(1) Objeto(i).pos(2)];
    end
    for i=1:length(Objeto2) 
     vObjeto2=[vObjeto2; Objeto2(i).pos(1) Objeto2(i).pos(2)];
    end
   end  
  
  
    plot(vRobo2(:,1),vRobo2(:,2),'sb',vRobo(:,1),vRobo(:,2),'sb',vAlvo(:,1),vAlvo(:,2),'xg',vObstaculo(:,1),vObstaculo(:,2),'xr',vObjeto(:,1),vObjeto(:,2),'o',vObjeto2(:,1),vObjeto2(:,2),'o');  
    axis([0 tamanho(1) 0 tamanho(2)]);
  drawnow
end