/*
 * Copyright 2014 - 2018 Stepan Perun
 * This program is free software.
 * License: Gnu Lesser General Public License
 * http://www.gnu.org/licenses/lgpl.html
*/


#ifndef GTV_MPEGTS_H
#define GTV_MPEGTS_H


#include <gtk/gtk.h>
#include <gst/gst.h>

#include <time.h>


#define MAX_RUN_PAT 128

struct GtvMpegts
{
	time_t t_cur, t_start;

	gboolean pat_done,  pmt_done,  sdt_done,  vct_done;
	guint    pat_count, pmt_count, sdt_count, vct_count;
};

struct GtvMpegts gtvmpegts;


struct GtvMpegtsPat { guint pmn_pid; guint  nmap;             } dvb_gst_pat_n[MAX_RUN_PAT];
struct GtvMpegtsPmt { guint pmn_pid; guint  vpid; guint apid; } dvb_gst_pmt_n[MAX_RUN_PAT];
struct GtvMpegtsSdt { guint pmn_pid; gchar *name;             } dvb_gst_sdt_n[MAX_RUN_PAT];
struct GtvMpegtsVct { guint pmn_pid; gchar *name;             } dvb_gst_vct_n[MAX_RUN_PAT];

void gtv_mpegts_initialize ();

void gtv_mpegts_parse_section  ( GstMessage *message );
void gtv_mpegts_parse_pmt_lang ( GstMessage *message );
void gtv_mpegts_clear_scan ();


#endif // GTV_MPEGTS_H
