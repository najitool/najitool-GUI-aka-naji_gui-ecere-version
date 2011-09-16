#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif
import "najicomm"
import "najicmds"
import "naji_ttt"
import "najicalc"
import "najihelp"
#include "naji_gui.eh"



#ifdef ECERE_STATIC
import static "ecere"
#else
import "ecere"
#endif


int xx=0;
int yy=0;


bool player_move = true;

char ttt_board[9] = {
' ', ' ', ' ',
' ', ' ', ' ',
' ', ' ', ' '
}; 

char ttt_winner = ' '; 

class ttt : Window
{
   text = "najitool GUI Tic-Tac-Toe";
   background = black;
   borderStyle = fixedBevel;
   hasMinimize = true;
   hasClose = true;
   tabCycle = true;
   size = { 471, 471 };

   
   bool OnCreate()
   {
      
      
       msgbox("najitool GUI Tic-Tac-Toe", "The aim of the game is to try to get 3 of your pieces\n"
       "in a row, be it horizontally, vertically or diagonally.\n"
       "Your pieces are represented by X and the computer's O.\n\n"
       "najitool cmd version by SAMUEL CHANG     (badp1ayer@hotmail.com)\n"
       "najitool GUI version by NECDET COKYAZICI (cokyazici@yahoo.co.uk)\n"
       );
  
  
        return true;
   }

   BitmapResource player_x_bitmap { ":player_x.pcx", window = this };
   BitmapResource player_o_bitmap { ":player_o.pcx", window = this };
   BitmapResource ttt_board_bitmap { ":ttt_board.pcx", window = this };

   void OnRedraw(Surface surface)
   {
      surface.Blit(ttt_board_bitmap.bitmap, 0,0, 0,0, ttt_board_bitmap.bitmap.width, ttt_board_bitmap.bitmap.height);
      
      if (ttt_board[0] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 0,0, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[1] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 162, 0, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[2] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 322, 0, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[3] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 0, 155, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[4] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 162, 155, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[5] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 322, 155, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[6] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 0, 315, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[7] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 162, 315, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);

      if (ttt_board[8] == 'X')
      surface.Blit(player_x_bitmap.bitmap, 322, 315, 0,0, player_x_bitmap.bitmap.width, player_x_bitmap.bitmap.height);


      if (ttt_board[0] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 0,0, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[1] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 162, 0, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[2] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 322, 0, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[3] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 0, 155, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[4] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 162, 155, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[5] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 322, 155, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[6] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 0, 315, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[7] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 162, 315, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);

      if (ttt_board[8] == 'O')
      surface.Blit(player_o_bitmap.bitmap, 322, 315, 0,0, player_o_bitmap.bitmap.width, player_o_bitmap.bitmap.height);
   }

   bool OnKeyDown(Key key, unichar ch)
   {
      if(key == escape) Destroy(0);
      return true;
   }

   bool OnLeftButtonDown(int x, int y, Modifiers mods)
   {
     xx = x;
     yy = y;

      if (player_move == true)
      {

      if (xx > 0)
      if (xx <= 157)
      if (yy > 0)
      if (yy <= 148)
      if (ttt_board[0] == ' ')
      {
      ttt_board[0]='X';
      player_move = false;
      }
      
      if (xx >= 162)
      if (xx <= 316)
      if (yy > 0)
      if (yy <= 148)
      if (ttt_board[1] == ' ')
      {
      ttt_board[1]='X';
      player_move = false;
      }


      if (xx >= 323)
      if (xx <= 468)
      if (yy > 0)
      if (yy <= 148)
      if (ttt_board[2] == ' ')
      {
      ttt_board[2]='X';
      player_move = false;
      }

      if (xx > 0)
      if (xx <= 157)
      if (yy > 156)
      if (yy <= 309)
      if (ttt_board[3] == ' ')
      {
      ttt_board[3]='X';
      player_move = false;
      }

      if (xx >= 162)
      if (xx <= 316)
      if (yy > 156)
      if (yy <= 309)
      if (ttt_board[4] == ' ')
      {
      ttt_board[4]='X';
      player_move = false;
      }

      if (xx >= 323)
      if (xx <= 468)
      if (yy > 156)
      if (yy <= 309)
      if (ttt_board[5] == ' ')
      {
      ttt_board[5]='X';
      player_move = false;
      }

      if (xx > 0)
      if (xx <= 157)
      if (yy > 316)
      if (yy <= 469)
      if (ttt_board[6] == ' ')
      {
      ttt_board[6]='X';
      player_move = false;
      }


      if (xx >= 162)
      if (xx <= 316)
      if (yy > 316)
      if (yy <= 469)
      if (ttt_board[7] == ' ')
      {
      ttt_board[7]='X';
      player_move = false;
      }


      if (xx >= 323)
      if (xx <= 468)
      if (yy > 316)
      if (yy <= 469)
      if (ttt_board[8] == ' ')
      {
      ttt_board[8]='X';
      player_move = false;
      }
      }

      if(ttt_gameover() == ' ')
      {
         if (player_move == false)
         ttt_computermove();  
      }
      else
      {
         ttt_displaywinner();
         ttt_restartgame();
      }
      Update(null);
      return true;
   }

   void ttt_restartgame(void)
   {
      int i;

      for (i=0; i<9; i++)
         ttt_board[i] = ' ';

      ttt_winner = ' ';
   }

   char ttt_gameover(void)
   {
      int i;
      int blankCount = 8;

      const int WIN_ROWS[8][3] =
      {
      {0,1,2},
      {3,4,5},
      {6,7,8},
      {0,3,6},
      {1,4,7},
      {2,5,8},
      {0,4,8},
      {2,4,6}
      };

     for (i=0; i<8; i++)
     {


             if ( (ttt_board[WIN_ROWS[i][0]] == 'X') &&
                  (ttt_board[WIN_ROWS[i][0]] == ttt_board[WIN_ROWS[i][1]]) &&
                  (ttt_board[WIN_ROWS[i][1]] == ttt_board[WIN_ROWS[i][2]]) )
                  {
                  /* winner is human */
                  ttt_winner = 'h';
                  return 'h';
                  }

             if ( (ttt_board[WIN_ROWS[i][0]] == 'O') &&
                  (ttt_board[WIN_ROWS[i][0]] == ttt_board[WIN_ROWS[i][1]]) &&
                  (ttt_board[WIN_ROWS[i][1]] == ttt_board[WIN_ROWS[i][2]]) )
                  {
                  /* winner is computer */
                  ttt_winner = 'c';
                  return 'c';
                  }
     }

     for (i=0; i<8; i++)
     {
        if (ttt_board[i] != ' ')
        blankCount--;
     }

     if (blankCount == 0 && ttt_winner == ' ')
     {
        /* game is a draw */
        ttt_winner = 'd';
        return 'd';
     }

     /* game is not over */
     ttt_winner = ' ';
     return ' ';
   }

   void ttt_displaywinner(void)
   {
      if (ttt_winner == 'h')
         MessageBox { text = "Tic-Tac-Toe", contents = "You Win! Well done." }.Modal(); 

      if (ttt_winner == 'c')
         MessageBox { text = "Tic-Tac-Toe", contents = "Sorry you lose... Try again!" }.Modal(); 

      if (ttt_winner == 'd')
         MessageBox { text = "Tic-Tac-Toe", contents = "It's a Draw... Try again!" }.Modal(); 
   }

   void ttt_computermove(void)
   {
      const int BESTMOVES[] = {4, 0, 2, 6, 8, 1, 3, 5, 7};
      int i;

      player_move = true;

        /* Step 1: Check and see if the computer can win */

        for (i=0; i<9; i++)
        {
          if (ttt_board[i] == ' ')
          {
               ttt_board[i] = 'O';

               if (ttt_gameover() == 'c')
               {
                  return;  /* Move has been made */
               }
               else ttt_board[i] = ' ';

          }
        }


        /* Step 2: Check and see if the human can win */

        for (i=0; i<9; i++)
        {
                if (ttt_board[i] == ' ')
                {
                        ttt_board[i] = 'X';

                        if (ttt_gameover() == 'h')
                        {
                        ttt_board[i] = 'O';
                        return;  /* Move has been made */
                        }

                        else ttt_board[i] = ' ';
                }
        }


        /* Step 3: Make the best possible remaining move */

        for (i=0; i<9; i++)
        {
                if (ttt_board[BESTMOVES[i]] == ' ')
                {
                ttt_board[BESTMOVES[i]] = 'O';
                return;  /* Move has been made */
                }
        }
   }
} /* class ttt : Window */
