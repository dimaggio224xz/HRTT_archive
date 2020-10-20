/*
 * без имени2.cxx
 * 
 * Copyright 2017 USER <USER@HRTT310>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
#include <iostream>
#include <stdio.h>
using namespace std;
const unsigned short n=7, r=3, k=4;
unsigned g[k]= {0x40,0x20,0x10,0x08}; //c*xr/p(xr)
unsigned gl[k]={0x40,0x20,0x10,0x08};
unsigned*p;
unsigned short i;
unsigned polinom = 0x58,polinom1, result,mask=0x40,mask1,mask2=0x04;//mask2=0100 r=3
extern void output_screen(unsigned);
int main ()
{
	for(short l=0; l<k; l++)
	{
		p=g;
	    p=p+l;
	    mask1 = mask;
	    polinom1=polinom;
	    i+=1;
	    for(short j=0; j<k; j++)
	    {
			result=*p&mask1;
			if(result !=0)
			{
				i+=l;
				*p=*p^polinom1;
			}
			mask1=mask1>>1;
			polinom1=polinom1>>1;
		}
	}
	cout<<"the enabling packets of G"<<n<<","<<k<<"matrix:\n";
	cout<<"\n";
	for (i=0;i<k;i++)
	{
		g[i]=gl[i]|g[i];
		output_screen(g[i]);
		cout<<"\n";
	}
		cout<<"\n";
		getchar();
		return 0;
	}
	void output_screen(unsigned var)
	{
		unsigned short var_l;
		unsigned mask = 0x40;
		var_l = var;
		for(int j=0; j<n; j++)
	{
		var =var&mask;
		if(var !=0)cout<<"l"; else cout<<"0";
		var=var_l;
		mask=mask>>1;
	}
	return;
}

