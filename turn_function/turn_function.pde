final int KURO = 1;
final int SHIRO = -1;
final int AKI = 0;
final int SOTO = 255;
final int BANSIZE = 640;
final int CELLSIZE = BANSIZE / 8;
final int STONESIZE = round(CELLSIZE * 0.9);

final int HITO = 1;
final int COMP = 2;

int[][] ban;
int teban;
int sente;
int gote;
int passCount;
int moveCount;


void setup()
{
  teban = KURO;

  sente = COMP;
  gote = HITO;

  passCount = 0;
  moveCount = 0;

  size(640, 640);
  ban = new int[10][10];
  for(int y=0; y<10; y++)
  {
    for(int x=0; x<10; x++)
    {
      ban[x][y] = AKI;
      if( x==0 || x==9 || y==0 || y==9 )
      {
        ban[x][y] = SOTO;
      }
      else
      {
        ban[x][y] = AKI;
      }
    }
  }
  ban[4][4] = SHIRO;
  ban[5][5] = SHIRO;
  ban[4][5] = KURO;
  ban[5][4] = KURO;
}

void showBan(int[][] b)
{
  background(0,96,0);
  for(int i=0; i<9; i++)
  {
    line(0,i*CELLSIZE,BANSIZE,i*CELLSIZE);
    line(i*CELLSIZE,0,i*CELLSIZE,BANSIZE);
  }

  for(int y=1; y<=8; y++)
  {
    for(int x=1; x<=8; x++)
    {
      switch(b[x][y])
      {
        case SOTO:
          break;
        case AKI:
          break;
        case KURO:
          fill(0);
          ellipse( round((x-0.5)*CELLSIZE), round((y-0.5)*CELLSIZE), STONESIZE, STONESIZE );
          break;
        case SHIRO:
          fill(255);
          ellipse( round((x-0.5)*CELLSIZE), round((y-0.5)*CELLSIZE), STONESIZE, STONESIZE );
          break;
      }

      // おける場所には赤丸
      if( turn(ban, teban, x, y) != 0 )
      {
        fill(255,0,0);
        ellipse( round((x-0.5)*CELLSIZE), round((y-0.5)*CELLSIZE), 10,10);
      }
    }
  }
}

void draw()
{
  showBan(ban);
}

void mouseClicked()
{
  println("(" + mouseX + "," + mouseY + ")");
  int gx = mouseX / CELLSIZE + 1;
  int gy = mouseY / CELLSIZE + 1;

  ban[gx][gy] = teban;
  teban = -teban;
}

// 盤面 b に、色 te の石を (x,y) に置こうとしたとき、(dx,dy) 方向に相手の石が何個ひっくり返せるか数えて答える関数
// (dx,dy) は、(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1) で８方向
int turnSub(int[][] b, int te, int x, int y, int dx, int dy)
{
  // 相手の石を数える変数
  int result = 0;

  // まず、置こうとしている場所の隣に移動する
  x += dx;
  y += dy;

  // そこが「相手の石の色である」あいだ、その数を数えながらその先に移動していく。
  while( b[x][y] == -te )
  {
    result++;
    x += dx;
    y += dy;
  }

  // 繰り返しを抜けるのは「相手の石でない」ものを発見したとき。このとき自分の石を見ていれば、ひっくり返せる。それまで
  // 自分の石でなければ、それまで何個数えていても、ひっくり返せるのは０個。
  if( b[x][y] == te )
  {
    return result;
  }
  else
  {
    return 0;
  }
}

// 盤面 b に、色 te の石を (x,y) に置こうとしたとき、全部で相手の石が何個ひっくり返せるか数えて答える関数
int turn(int[][] b, int te, int x, int y)
{
  // 空いているかどうか、ここでチェックすることにする。
  // 置こうとしてる場所が AKI でないなら、一個もひっくり返せない。
  if( b[x][y] != AKI )
  {
    return 0;
  }

  // 総数を数える準備。
  int result = 0;

  // (-1,-1) 方向の数を数える。
  result += turnSub(b, te, x, y, -1, -1);
  // あと７方向全部数えて足し合わせる。
  result += turnSub(b, te, x, y, -1,  0);
  result += turnSub(b, te, x, y, -1,  1);
  result += turnSub(b, te, x, y,  0, -1);
  result += turnSub(b, te, x, y,  0, -1);
  result += turnSub(b, te, x, y,  1, -1);
  result += turnSub(b, te, x, y,  1,  0);
  result += turnSub(b, te, x, y,  1,  1);

  return result;
}
