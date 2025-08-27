# Why I built this app

I fill in a very detailed daily mood journal and share it with my therapist every week. 
I started with an Excel spreadsheet as the weekly template. 
Every week, I duplicated this file and cleared contents to make space for the new week. 
Every part of it was a pain. And it needed lots of formatting to be readable in the file as well as when exported. 

The issues I had were that it was 
1. Ugly
2. Tedious to fill -- too many phone taps
3. Difficult to export (to share)
4. Difficult to fill on my phone
5. Difficult to export (to share) on my phone
6. A weekly file, and so, needed file duplication. 

To make this easier, I made a Notion database for each of the three group of measures in my spreadsheet. 
This made it a lot less ugly. Notion looks really neat! 
It also didn't need manual duplication because I could set it up to auto-create a card everyday, 
and most importantly for me, I could fill it on my phone.

The other pain points remained. Notion’s exported PDF was neat but it couldn’t pivot data, which I needed for readability. 
I wrote a Python script that used Notion’s APIs for the data and created a PDF. 
That gave me finer-grained control over the format. 
Notion reduced the tedium of filling as well as exporting but didn't fully remove it. 
I could export only on my laptop. 
Small changes became complex because I had 3 databases. 
Using 1 database still needed too many finger taps to fill. And the length felt intimidating.

I figured the most tailored experience would be from an app I built from scratch, according to my tastes. 
I knew no Swift, no app development and little TypeScript. 
I landed on making a native iOS app to have the most seamless interface.  

I didn't try learning Swift through tutorials or courses before I started. I simply jumped in and learnt as I went.
It was far more interesting *and rewarding* than tutorials or courses. 
The first 2 weeks were frustrating and unintuitive due to my unfamiliarity with Swift's syntax. 
I got comfortable gradually, cursed Swift lesser and lesser, and managed to build a minimum functional app. 
Obviously, I started using it right away.  
As the next step, I worked on making the app prettier and more reliable. 
Simultaneously, I spent time reading up on Swift's features and conventions so I could prettify my code along with the app.
I felt Xcode’s predictions and ChatGPT made it hard to learn, so I didn't specifically seek their help. 
I think I learnt enough to write super-readable code. Doesn't [this](https://github.com/sriram-rao/diarycard/blob/59addf7e733ce8e9f9b826d1fdf0ff466281471e/DiaryCard/Model/Extensions/HtmlExtensions.swift#L120C9-L133C46) read like English? 

For prettiness, I tried sticking to a minimal design. I focused on the elements being 
* well-ordered, 
* placed according to usage, 
* formatted only to inform. 
I'm quite happy with the way these self-made guidelines worked out.

I made sure to cover my pain points list too. 
* The input form uses space better to make it not seem long. 
* A button moves the cursor to the next field’s input area to save finger taps. 
In Notion, I had to tap to activate a field, type, tap to deactivate it, and repeat. 
The deactivate field and activate next field taps could not be combined.  
* A button exports the previous seven days of data to PDF. (Seven days is my default, I can choose any duration.)  
* A button jumps directly to the current day’s card for easy access. 
The card would be created automatically if it didn't exist, giving me functionality comparable to Notion. 

Now because it’s code I wrote, I look forward to filling my measures even though they're still a bit of a pain. 
