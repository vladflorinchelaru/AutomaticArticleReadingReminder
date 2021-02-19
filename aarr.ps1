# AARR Automatic Article Reading Reminder 1.0 (C) Vlad-Florin Chelaru, 19.02.2021, Bacau, Romania
# Available at github.com/vladflorinchelaru
echo 'AARR Automatic Article Reading Reminder 1.0 (C) Vlad-Florin Chelaru, 19.02.2021, Bacau, Romania'
echo 'Available at https://github.com/vladflorinchelaru'
echo 'EN: This Program comes with ABSOLUTELY NO WARRANTY; check https://www.gnu.org/licenses/gpl-3.0.html'
echo 'This program is FREE software, and you are welcome to redistribute it under certain conditions (see link)!'
echo 'THIS PROGRAM IS IN NO WAY INTENDED FOR COPYRIGHT INFRINGEMENT, BUT FOR EASING THE ACCESS TO SCIENTIFIC LITERATURE.'
echo 'THE END USER IS THE ONLY PERSON RESPONSIBLE FOR ILLICIT ACTIVITIES DONE THROUGH THIS SCRIPT.'
echo 'RO: Acest program NU este insotit DE NICIO GARANTIE; vezi https://www.gnu.org/licenses/gpl-3.0.html'
echo 'Acest program constituie software LIBER/GRATUIT si esti invitat sa-l redistribui, cu anumite conditii (vezi link)!'
echo 'ACEST PROGRAM NU INTENTIONEAZA, IN NICIUN MOD, SA INCALCE DREPTURILE DE AUTOR, CI SA USUREZE ACCESUL LA LITERATURA STIINTIFICA.'
echo 'UTILIZATORUL FINAL ESTE SINGURUL RESPONSABIL DE UTILIZAREA ACESTUI SCRIPT IN SCOPURI ILICITE.'
# IMPORTANT NOTICE FOR AUTOMATIC ACCESS
# If you (or your institution) use(s) any web service that automatically logs you in and enables you to directly view the PDF without a paywall hassle
#  please enter the address of that web service in the $SCHB variable.
# For example, if $SCHB="contoso.ro/" and inside $listfile the DOI is written as "https://doi.org/10.1007/s11192-020-03806-w"
#  then the script will access "contoso.ro/autologon/https://doi.org/10.1007/s11192-020-03806-w" instead of going directly to "https://doi.org/10.1007/s11192-020-03806-w".
# Do note that the script does not insert a "/" between $SCHB and the DOI link read from the file, and as such $SCHB should end with a slash (as per the example).
# IF YOU DON'T USE such systems and the script should go directly to doi.org, then please set $SCHB = "" (just the quotations marks, no space between them)!
$SCHB = ""
# check if there is any implicit file (denoted by $listfile initial value) in the working directory
#    if yes, then read that file
#    if no, then ask for a file to read
$listfile = "aarr_list.txt"
if(!(Get-ChildItem -name -file).Contains($listfile))
{
    $listfile = Read-Host 'File of DOI''s'
}
echo "Processing links from the file $listfile !"
# reading the $listfile line by line and treating each entry
foreach ($line in Get-Content $listfile)
{
    echo "Processing line:   $line"
    if(!$line.Contains("doi.org"))
    {
		# just a warning in case the user inserts a link from the journal website, not the DOI;
		# DOI codes without the domain part will work when used with $SCHB (e.g. "contoso.ro/autologon/10.1007/s11192-020-03806-w")
        echo "Warning! This line might not be a valid doi.org link."
    }
    $response = Invoke-WebRequest "$SCHB$line" # request HTML from DOI or through #SCHB
    echo "   Response status code $($response.StatusCode)" # print status code for debug
    if($response.StatusCode -eq 200) #for now, we only consider as desired only status code 200, though in the future 2xx codes might be better suited
    {
        if($response.Content -match '<iframe src = "(\S+.pdf)') # returns true if link to pdf is found in the HTML of the page
        {
            echo "   Matched to an iframe containing a PDF reference."
            echo "   Link to PDF is found:   $($Matches[1])"
            $i=1
            while((Get-ChildItem -name -file).Contains("$i.pdf")) # check for a PDF number that doesn't exist yet
            {
                $i++
            }
            echo "   Saving to file:   $i.pdf"
            Invoke-WebRequest $Matches[1] -OutFile "$i.pdf" # download the PDF
            if(!(Get-ChildItem -name -file).Contains("$i.pdf")) 
            {
				# sometimes Invoke-WebRequest bamboozles itself, and the best way to check for that is to check the presence of the PDF
				# if there's no PDF, then we'll check this link again next time (at the next run)
                echo "   File $i.pdf does not exist after issuing download request. This link will be kept for the next time."
                echo $line >> "$listfile.tmp" #this is the (temp) file where links that we couldn't download will be stored for the next run
            }
        }
        else
        {
			# self-explanatory, if there's no reference of a PDF link then we'll keep this link for the next run
            echo "   No match for an PDF-containing iframe. This link will be kept for the next time."
            echo $line >> "$listfile.tmp"
        }

    }
    else
    {
		# if the status code for the request is not 200, then we consider this unsuccessful and we keep the link for the next run
        echo "   This link will be kept for the next time."
        echo $line >> "$listfile.tmp"
    }
}
echo "Parsed all the lines. Doing cleanup..."
$i=1
while((Get-ChildItem -name -file).Contains("$listfile.old$i")) # we keep old, processed versions of $listfile in case this script bamboozles itself
{
    $i++
}
echo "Old file will be renamed to:   $listfile.old$i"
mv $listfile "$listfile.old$i"
echo "New file will be renamed to:   $listfile"
mv "$listfile.tmp" $listfile # the temp file becomes the default file for the next run
echo "Cleanup complete, the script reached its end. Thank you for using this shit."
echo 'AARR Automatic Article Reading Reminder 1.0 (C) Vlad-Florin Chelaru, 19.02.2021, Bacau, Romania'
echo 'Available at https://github.com/vladflorinchelaru'