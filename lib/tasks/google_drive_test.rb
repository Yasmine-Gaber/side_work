require "google_drive"

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
session = GoogleDrive::Session.from_config("client_secret.json")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
# ws = session.spreadsheet_by_key("pz7XtlQC-PYx-jrVMJErTcg").worksheets[0]
# "19eDIldQXXuFPEz3770sxkYOxEPYP8-5P7nrNLa3L4a0"
ws = session.spreadsheet_by_key("1CzoO48wyWzDVh809Af5p0JjWdIgw_4L8zM15XHlZP80").worksheets[0]
# Gets content of A2 cell.
p ws[2, 1]  #==> "hoge"

# Changes content of cells.
# Changes are not sent to the server until you call ws.save().
ws[9, 1] = "foo"
ws[9, 2] = "bar"
# ws[9] = ["foo2", "bar2"]
ws.save

p ws.num_rows
# Dumps all cells.
# (1..ws.num_rows).each do |row|
#   (1..ws.num_cols).each do |col|
#     p ws[row, col]
#   end
# end

# Yet another way to do so.
# p ws.rows  #==> [["fuga", ""], ["foo", "bar]]

# Reloads the worksheet to get changes by other clients.
# ws.reload
