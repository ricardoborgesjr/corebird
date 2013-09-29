/*  This file is part of corebird, a Gtk+ linux Twitter client.
 *  Copyright (C) 2013 Timm Bäder
 *
 *  corebird is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  corebird is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with corebird.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;

[GtkTemplate (ui = "/org/baedert/corebird/ui/user-list-entry.ui")]
class UserListEntry : Gtk.ListBoxRow, ITwitterItem {
  [GtkChild]
  private Label name_label;
  [GtkChild]
  private Label screen_name_label;
  [GtkChild]
  private Image avatar_image;

  public new string name {
    set { name_label.label = value; }
  }

  public string screen_name {
    set { screen_name_label.label = value; }
  }

  public string avatar {
    set { real_set_avatar (value); }
  }

  public bool seen {
    get { return true; }
    set {}
  }

  public int64 sort_factor {
    get{ return int64.MAX-1; }
  }

  public int64 user_id { get; set; }

  private void real_set_avatar (string avatar_url) {
    Gdk.Pixbuf a = TweetUtils.load_avatar (avatar_url);
    if (a != null) {
      avatar_image.pixbuf = a;
      return;
    }

    TweetUtils.download_avatar.begin (avatar_url, (obj, res) => {
      var pic = TweetUtils.download_avatar.end (res);
      TweetUtils.load_avatar (avatar_url, pic);
      avatar_image.pixbuf = pic;
    });
  }
}
