  url "https://github.com/v1cont/yad/archive/v0.40.3.tar.gz"
  sha256 "a63a88ea1946a6ba5d45921abed6b53558215ca4b93b4cd7205de00e9a4848bb"
    url "https://github.com/v1cont/yad.git"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build
  patch :p0, :DATA
    ENV.prepend_path "PKG_CONFIG_PATH", "/opt/X11/lib/pkgconfig"
    system "gettextize"
    inreplace "configure.ac", "AC_CONFIG_FILES([ po/Makefile.in", "AC_CONFIG_FILES(["
    inreplace "configure.ac", "IT_PROG_INTLTOOL([0.40.0])", ""
    system "autoreconf -ivf"
    system "./configure", "--disable-dependency-tracking",
    inreplace "Makefile", "SUBDIRS = src po data", "SUBDIRS = src data"
diff -Naur src/main.c src.mod/main.c
--- src/main.c	2018-01-20 11:26:14.000000000 +0100
+++ src.mod/main.c	2018-10-07 11:33:21.000000000 +0200
@@ -46,6 +48,7 @@
 gint t_sem;
@@ -64,6 +67,7 @@
     yad_exit (YAD_RESPONSE_CANCEL);
 static gboolean
 keys_cb (GtkWidget *w, GdkEventKey *ev, gpointer d)
@@ -269,6 +273,7 @@
@@ -277,6 +282,7 @@
@@ -646,6 +652,7 @@
@@ -667,6 +674,7 @@
         }
 #if GTK_CHECK_VERSION(3,0,0)
   if (css)
@@ -676,6 +684,7 @@
@@ -712,6 +721,7 @@
 yad_print_result (void)
@@ -739,12 +749,14 @@
@@ -879,6 +891,7 @@
@@ -886,7 +899,9 @@
@@ -895,6 +910,7 @@
@@ -930,11 +946,14 @@
       dialog = create_dialog ();
@@ -942,9 +961,12 @@
         }
@@ -965,10 +987,12 @@
diff -Naur src/notebook.c src.mod/notebook.c
--- src/notebook.c	2018-01-20 11:26:14.000000000 +0100
+++ src.mod/notebook.c	2018-10-07 10:56:10.000000000 +0200
@@ -145,3 +148,4 @@
diff -Naur src/option.c src.mod/option.c
--- src/option.c	2018-01-20 11:26:14.000000000 +0100
+++ src.mod/option.c	2018-10-07 11:09:51.000000000 +0200
@@ -39,16 +39,20 @@
 static gboolean set_posx (const gchar *, const gchar *, gpointer, GError **);
 static gboolean set_posy (const gchar *, const gchar *, gpointer, GError **);
 #ifndef G_OS_WIN32
+#ifdef GDK_WINDOWING_X11
 static gboolean set_xid_file (const gchar *, const gchar *, gpointer, GError **);
 static gboolean parse_signal (const gchar *, const gchar *, gpointer, GError **);
 #endif
+#endif
 static gboolean add_image_path (const gchar *, const gchar *, gpointer, GError **);
 static gboolean set_complete_type (const gchar *, const gchar *, gpointer, GError **);
 static gboolean set_grid_lines (const gchar *, const gchar *, gpointer, GError **);
@@ -78,9 +82,13 @@
@@ -168,11 +176,13 @@
     N_("Tab number of this dialog"), N_("NUMBER") },
     N_("Send SIGNAL to parent"), N_("[SIGNAL]") },
   { "print-xid", 0, G_OPTION_FLAG_OPTIONAL_ARG, G_OPTION_ARG_CALLBACK, set_xid_file,
     N_("Print X Window Id to the file/stderr"), N_("[FILENAME]") },
 };
 
@@ -468,12 +478,15 @@
     /* xgettext: no-c-format */
     N_("Dismiss the dialog when 100% of all bars has been reached"), NULL },
 #ifndef G_OS_WIN32
+#ifdef GDK_WINDOWING_X11
   { "auto-kill", 0, G_OPTION_FLAG_NOALIAS, G_OPTION_ARG_NONE, &options.progress_data.autokill,
     N_("Kill parent process if cancel button is pressed"), NULL },
 #endif
+#endif
@@ -487,6 +500,7 @@
     N_("Set active tab"), N_("NUMBER") },
@@ -502,6 +516,7 @@
@@ -511,6 +526,7 @@
@@ -837,12 +853,14 @@
@@ -1017,6 +1035,7 @@
@@ -1033,6 +1052,7 @@
@@ -1070,6 +1090,7 @@
@@ -1082,6 +1103,7 @@
@@ -1204,6 +1226,7 @@
 #endif
 
 #ifndef G_OS_WIN32
+#ifdef GDK_WINDOWING_X11
 static gboolean
 set_xid_file (const gchar * option_name, const gchar * value, gpointer data, GError ** err)
 {
@@ -1310,6 +1333,7 @@
   return TRUE;
 }
 #endif
+#endif
 
 void
 yad_set_mode (void)
@@ -1338,12 +1362,16 @@
@@ -1377,10 +1405,12 @@
   options.xid_file = NULL;
   options.hscroll_policy = GTK_POLICY_AUTOMATIC;
   options.vscroll_policy = GTK_POLICY_AUTOMATIC;
@@ -1572,11 +1602,13 @@
   options.notebook_data.active = 1;
@@ -1584,9 +1616,11 @@
   options.notification_data.icon_size = 16;
@@ -1602,8 +1636,10 @@
   options.progress_data.pulsate = FALSE;
   options.progress_data.autoclose = FALSE;
 #ifndef G_OS_WIN32
+#ifdef GDK_WINDOWING_X11
   options.progress_data.autokill = FALSE;
 #endif
+#endif
   options.progress_data.rtl = FALSE;
   options.progress_data.log = NULL;
   options.progress_data.log_expanded = FALSE;
@@ -1729,11 +1765,13 @@
@@ -1742,11 +1780,13 @@
diff -Naur src/paned.c src.mod/paned.c
--- src/paned.c	2018-01-20 11:26:14.000000000 +0100
+++ src.mod/paned.c	2018-10-07 11:10:50.000000000 +0200
@@ -123,3 +126,4 @@
diff -Naur src/yad.h src.mod/yad.h
--- src/yad.h	2018-01-20 11:26:14.000000000 +0100
+++ src.mod/yad.h	2018-10-07 11:17:22.000000000 +0200
@@ -482,9 +484,13 @@
@@ -507,7 +513,9 @@
 
   gchar *xid_file;
 #endif
@@ -538,7 +546,7 @@
@@ -566,16 +574,20 @@
 gboolean file_confirm_overwrite (GtkWidget *dlg);
@@ -585,8 +597,10 @@
@@ -598,8 +612,10 @@