
import os 
import pandas as pd 
import matplotlib.pyplot as plt  
import numpy as np 


path = os.getcwd() 
df_acc = pd.read_csv(f'{path}\\Accounts.csv') 
df_dep = pd.read_csv(f'{path}\\Deposits.csv') 
df_clients = pd.read_csv(f'{path}\\Clients.csv') 



# ============================================================================
# 1.כמות חשבונות תמורה וחשבונות עובר ושב שנפתחו בכל רביעון ובכל שנה של התקופה 2018-2022.

# ============================================================================
def open_acc(df_acc):
    
    
    df_acc['DateAccountOpening'] = pd.to_datetime(df_acc['DateAccountOpening'])
    # ממירים את העמודה DateAccountOpening לתאריך מסוג datetime
   
    df_acc = df_acc[(df_acc['DateAccountOpening'].dt.year.between(2018, 2022))& 
        (df_acc['AccountType'].isin(['Savings', 'Current']))].copy()
    #מסנים את החשבונות שנפתחו בתקופה 2018–2022,
# סוגי החשבון Savings" (חשבון תמורה רק לשמירת כסף וחסכונות) או Current" (עו"ש),
#copy() – מייצר עותק חדש כדי למנוע אזהרות של פנדס 

    df_acc['Year'] = df_acc['DateAccountOpening'].dt.year #יוצרים עמודת שנה
    df_acc['Quarter'] = df_acc['DateAccountOpening'].dt.quarter  #יוצרים עמודת ורבעון 
   
    quantity_acc = df_acc.groupby(['Year', 'Quarter', 'AccountType']).size().reset_index(name='Quantity')
#groupby – קיבוץ הנתונים לפי שנה, רבעון וסוג חשבון.
#size() – סופר את מספר השורות בכל קבוצה.
#reset_index(name="Quantity") – ממיר את התוצאה ל-DataFrame עם עמודה בשם 'Quantity'.

    print('Number of open accounts by years, quaters and types')
    print(quantity_acc)
    
  
    total_quantity_acc = quantity_acc.groupby(['Year', 'AccountType'])['Quantity'].sum().unstack(fill_value=0)
#בשביל לצייר גרף סוכמים את כמות החשבונות לפי שנה וסוג החשבון לפי שנה#
#unstack() – הופכים את סוג החשבון לעמודות לכל סוג חשבון.    
    
    print('Number of open accounts by years and types')
    print(total_quantity_acc)
    
    #==========================================================================
    #מייצרים גרף בר#    
    #==========================================================================
    
    years = total_quantity_acc.index.astype(str) #מגדירים רשימת השנים
    x = np.arange(len(years)) #מגדירים מיקום כל בר בגרף
    width = 0.4 #מגדירים רוחב הבר בגרף
    
    plt.figure(figsize=(10,6))#יוצר גרף חדש בגודל 6*10
    
    plt.bar(x - width/2, total_quantity_acc['Savings'], width, label='Savings', color='green')
    #מציירים בר עבור חשבונות חיסכון.
    plt.bar(x + width/2, total_quantity_acc['Current'], width, label='Current', color='red')
    #מציירים בר עבור חשבונות עו"ש.
   
    for i, year in enumerate(years):
        plt.text(i - width/2, total_quantity_acc.loc[int(year), 'Savings']*1.01,
                 str(total_quantity_acc.loc[int(year), 'Savings']),
                 ha='center', va='bottom', fontsize=10, fontweight='bold') 
        #מוסיפים את מספר החשבונות מעל ברים של חשבונות חסכון בגרף    
        
        plt.text(i + width/2, total_quantity_acc.loc[int(year), 'Current']*1.01,
                 str(total_quantity_acc.loc[int(year), 'Current']),
                 ha='center', va='bottom', fontsize=10, fontweight='bold')
 #מוסיפים את מספר החשבונות מעל ברים של חשבונות עו"ש בגרף    
    
    plt.xlabel('Year', fontsize=14, fontweight='bold') # x מוסיפים כותרת לציר 
    plt.ylabel('Number of open accounts', fontsize=14, fontweight='bold') # y מוסיפים כותרת לציר 
    
    plt.xticks(x, years, fontsize=12, fontweight='bold') # x מגדירים את התוויות על ציר
    plt.yticks(fontsize=12, fontweight='bold') # y מגדירים את התוויות על ציר        
    plt.title('Number of open accounts by years and types', fontsize=16, fontweight='bold') # מוסיפים כותרת לגרף
    plt.legend(title='Account type', fontsize=12) # מוסיפים לגנדה עם הסבר לצבעי העמודות
    plt.tight_layout()  # מארגנים שהתוויות לא יחתכו
    plt.show() # מציגים את הגרף

    #==========================================================================
    #מייצרים גרפים קווים לכל שנה ולכל סוג חשבון #    
    #==========================================================================

    years = quantity_acc['Year'].unique()
    # הפקודה מחזירה את כל השנים הייחודיות בעמודה Year    
    for year in years: #לולאה שעוברת על כל שנה ברשימת השנים
        data_year = quantity_acc[quantity_acc['Year'] == year]
        #מסננים את הטבלה כך שתישאר רק השנה הנוכחית בלולאה        
        plt.figure(figsize=(10,6)) #יוצרים גרף בגודל 6*10

        for acc_type in data_year['AccountType'].unique(): # לולאה שעוברת על סוגי החשבונות
            data_type = data_year[data_year['AccountType'] == acc_type]
            #מסננים את הנתונים כך שישארו רק השורות של סוג החשבון הנוכחי       
            plt.plot(data_type['Quarter'], data_type['Quantity'], marker='o', linewidth=3,
                label=acc_type) #מציירים קווים בגרף 
            
        plt.title(f'Accounts opened by quarters {year}', fontsize=16, fontweight='bold') 
        #מוסיפים כותרת לגרף        
        plt.xlabel('Quarter', fontsize=14, fontweight='bold') # x מוסיפים כותרת לציר
        plt.ylabel('Number of opened accounts', fontsize=14, fontweight='bold') 
        # y מוסיפים כותרת לציר
        plt.xticks([1,2,3,4], fontsize=12, fontweight='bold') # x מגדירים מספרים של רבעונים בציר
        plt.yticks(fontsize=12, fontweight='bold') # y מגדירים מספרים של רבעונים בציר
        plt.legend(title='Account type', title_fontproperties={'weight':'bold'})
        #מוסיפים לגנד שמסביר מה כל קו מייצג        
        plt.grid(True) # מוסיפים קווי רשת על הגרף
        plt.tight_layout() #  מסדריפ את המרווחים כדי שהטקסט לא ייחתך
        plt.show() # מציג את הגרף על המסך
open_acc(df_acc)

# ============================================================================
# 2. 5 סניפים שפתחו כמות חשבונות גדולה ביותר בתקופה 2018-2022.

# ============================================================================
def top_branches():
    
    df_acc['DateAccountOpening'] = pd.to_datetime(df_acc['DateAccountOpening']) 
    # ממירים את העמודה DateAccountOpening לתאריך מסוג datetime
    
    df_acc_filtered = df_acc[(df_acc['DateAccountOpening'] >= '2018-01-01') &
        (df_acc['DateAccountOpening'] < '2023-01-01')] # מסננים את החשבונות שנפתחו בין 2018–2022

    top_branches = (df_acc_filtered.groupby("BranchID").size()
        .reset_index(name = 'TotalQuantityOpenAccounts')) #סופרים את מספר החשבונות שנפתחו בכל סניף

    top_branches['rnk'] = (top_branches['TotalQuantityOpenAccounts']
        .rank(method = 'min', ascending=False)) #מדרגים את הסניפים לפי כמות החשבונות שנפתחו

    top_branches_5 = (top_branches[top_branches["rnk"] <= 5]
        .sort_values('TotalQuantityOpenAccounts', ascending=True)) 
    #בוחרים את חמשת הסניפים שפתחו יותר חשבונות בתקופה 2018-2022 ומסדרים לפי כמות החשבונות
    
    print(top_branches_5)
    
    #==========================================================================
    #מייצרים גרף Hבר #    
    #==========================================================================
    
    plt.figure(figsize=(8,5)) # 8*5 יוצרים גרף חדש בגודל 
    
    bars = plt.barh(top_branches_5['BranchID'].astype(str),
#ממירים את המספרים לטקסט כדי שיופיעו יפה על הציר
        top_branches_5['TotalQuantityOpenAccounts'], color='lime') 
    #מייצגים מספר החשבונות שנפתחו בכל סניף
    
    plt.xlabel('Total accounts quantity', fontsize=11, fontweight='bold') # x מוסיפים כותרת לציר 
    plt.ylabel('Branch number', fontsize=11, fontweight='bold') # y מוסיפים כותרת לציר 
    plt.title('Top 5 Branches by Opened Accounts (2019–2022)',fontsize=14, fontweight='bold') 
    # מוסיפים כותרת לגרף
    plt.xticks(range(0, int(top_branches_5['TotalQuantityOpenAccounts'].max())+3, 2), 
               fontweight='bold')
      #קובעים את התוויות בציר x לפי מרווחים של 2
    #מחפשים את מספר החשבונות הגדול ביותר
    plt.yticks(fontweight='bold')
  
    for bar in bars: # לולאה שעוברת על כל עמודה בגרף
        width = bar.get_width() #השורה מחזירה את אורך העמודה
        plt.text(width - width*0.05, bar.get_y() + bar.get_height()/2, f'{int(width)}', 
            va='center', ha='right', fontweight='bold')   
        #מוסיפים את מספר החשבונות מעל כל בר
    
    plt.tight_layout() # מארגנים שהתוויות לא יחתכו
    plt.show() # מציגים את הגרף
top_branches()

# ============================================================================
# 3. סכומים כספים שהופקדו בפיקדונות בכל רביעון ובכל שנה של התקופה 2018-2022.

# ============================================================================
def open_dep(df_dep):
    
    df_dep['DateDepositOpening'] = pd.to_datetime(df_dep['DateDepositOpening'])
     # ממירים את העמודה DateDepositOpening לתאריך מסוג datetime
    
    df_dep = df_dep[df_dep['DateDepositOpening'].dt.year.between(2018, 2022)].copy()
    #מסנן פקדונות שנפתחו בין 2018–2022
    
    df_dep['Year'] = df_dep['DateDepositOpening'].dt.year #יוצרים עמודת שנה
    df_dep['Quarter'] = df_dep['DateDepositOpening'].dt.quarter #יוצרים עמודת רבעון
        
    total_sum_dep = pd.pivot_table(df_dep, values='AmountDeposit', index='Year', columns='Quarter',
        aggfunc='sum', fill_value=0)   
    #סוכם את סכום הפקדונות בכל שנה ובכל רבעון ובונים טבלת pivot
    print('Deposits by years and quarters')
    print(total_sum_dep)
    
    #==========================================================================
    #מייצרים גרף קווים לכל שנה #    
    #==========================================================================
        
    plt.figure() #יוצרים גרף 
    
    for year in total_sum_dep.index: 
        plt.plot(total_sum_dep.columns, total_sum_dep.loc[year], marker='o', label=year)
    # מציירים קו לכל שנה עם נקודות על כל רבעון
    
    plt.title('Deposits by quarters (2018–2022)') # מוסיפים כותרת לגרף
    plt.xlabel('Quarters') # x מוסיפים כותרת לציר 
    plt.ylabel('Deposit amounts') # y מוסיפים כותרת לציר 
    plt.xticks([1,2,3,4]) # מגדירים את התוויות על ציר כרבעונים 1–4
    plt.legend(title = 'Years') # מוסיפים לגנדה עם הסבר לשנים
    plt.show() # מציגים את הגרף
open_dep(df_dep)

    # ============================================================================
# 4. כמות חשבונות שנסגרו בכל חודש בשנת 2023.

    # ============================================================================
def close_acc():    
    
    df_acc['DateAccountClosing'] = pd.to_datetime(df_acc['DateAccountClosing'])
 # ממירים את העמודה DateAccountClosing לתאריך מסוג datetime   
    
    df_acc_2023 = df_acc[(df_acc['DateAccountClosing'].dt.year == 2023)& 
                         df_acc['DateAccountClosing'].notna()].copy()
    #מסננים חשבונות שנסגרו בשנת 2023 בלבד   
    
    df_acc_2023['Year'] = df_acc_2023['DateAccountClosing'].dt.year #יוצרים עמודת שנה
    df_acc_2023['Month'] = df_acc_2023['DateAccountClosing'].dt.month #יוצרים עמודת רבעון
    
    monthly_close = df_acc_2023.groupby(['Year', 'Month']).size().reset_index(name='QuantityCloseAccount')       
    #סופרים חשבונות שנסגרו בכל חודש    
    
    print('Closed accounts per month in 2023:')
    print(monthly_close)  
    
    #==========================================================================
    #מייצרים גרף עוגה #    
    #==========================================================================
   
    month_labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] # יוצרים רשימת שמות חודשים לגרף
    
    labels = [month_labels[m-1] for m in monthly_close['Month']] #ממירים את מספר החודש לשם החודש
    
    plt.figure(figsize=(8,8)) #יוצרים גרף עוגה חדש בגודל 8 על 8
    plt.pie(monthly_close['QuantityCloseAccount'], labels=labels,  startangle=85,
        textprops={'fontsize':12, 'fontweight':'bold'}) 
    # יוצרים גרף עוגה עם פרמטרים מסויימים
    
    plt.title('Closed accounts per month in 2023', fontsize=14, fontweight='bold') # מוסיפים כותרת לגרף
    plt.tight_layout() # מארגנים שהתוויות לא יחתכו
    plt.show() # מציגים את הגרף 
close_acc()

# ============================================================================
# 5. קורלציה בין כמות תלונות של לקוחות וכמות חשבונות שנסגרו בכל חודש של שנת 2023.

# ============================================================================
def corr_compl_close_acc():

    df_acc['DateAccountClosing'] = pd.to_datetime(df_acc['DateAccountClosing'])
    # ממירים את העמודה DateAccountClosing לתאריך מסוג datetime
    
    df_clients['FeedbackDate'] = pd.to_datetime(df_clients['FeedbackDate'])
    # ממירים את העמודה FeedbackDate לתאריך מסוג datetime
    
    closed_2023 = df_acc[df_acc['DateAccountClosing'].dt.year == 2023].copy()
    #מסננים חשבונות שנסגרו בשנת 2023 בלבד
    
    closed_2023['Month'] = closed_2023['DateAccountClosing'].dt.month #יוצרים עמודת חודש עבור חשבונות שנסגרו
    closed_2023['Year'] = closed_2023['DateAccountClosing'].dt.year #יוצרים עמודת שנה עבור חשבונות שנסגרו
    
    closed_month = (closed_2023.groupby(['Year', 'Month']).size()
                    .reset_index(name = 'ClosedAccounts'))
    #סופרים את כמות החשבונות שנסגרו בכל חודש
    
    complaints_2023 = df_clients[(df_clients['FeedbackType'] == 'Complaint') & 
                      (df_clients['FeedbackDate'].dt.year == 2023)].copy()
    #מסננים רק את התלונות שהתקבלו בשנת 2023
   
    complaints_2023['Month'] = complaints_2023['FeedbackDate'].dt.month #יוצרים עמודת חודש עבור התלונה
    complaints_2023['Year'] = complaints_2023['FeedbackDate'].dt.year #יוצרים עמודת שנה עבור התלונה
    
    
    complaints_month = (complaints_2023.groupby(['Year', 'Month']).size()
                        .reset_index(name = 'Complaints'))
     # #סופרים את כמות תלונות בכל חודש
     
    df_corr = pd.merge(closed_month, complaints_month, on=['Year', 'Month'], how='left')
#מאחדים את הנתונים כמות של תלונות וכמות של חשבונות שנסגרו לפי שנה וחודש
    print(df_corr)
    
    correlation = df_corr['ClosedAccounts'].corr(df_corr['Complaints'])
    # מחשבים את הקורלציה בין מספר תלונות ומספר חשבונות שנסגרו
    print('Correlation between complaints and closed accounts', correlation)
    
    #==========================================================================
    #מייצרים גרף סקאטר #    
    #==========================================================================
    
    plt.figure(figsize=(8,5)) #יוצרים גרף פיזור בגודל 8 על 5
    
    plt.scatter(df_corr["Complaints"], df_corr['ClosedAccounts'], color='red', s=70)
    #מציירים את הנתונים כנקודות
    
    for i, month in enumerate(df_corr['Month']):
        plt.text(df_corr['Complaints'][i]+0.25, df_corr['ClosedAccounts'][i],
                 str(month), fontsize=11, fontweight='bold', color='green')
    #מוסיפים את מספר החודש ליד כל נקודה בגרף
    
    m, b = np.polyfit(df_corr['Complaints'], df_corr['ClosedAccounts'], 1)
    #מחשבים את קו המגמה (רגרסיה לינארית)
    
    plt.plot(df_corr['Complaints'], m*df_corr['Complaints'] + b, color='green', 
             linestyle='-', linewidth=3) #מציירים את קו המגמה על הגרף
    
    plt.xticks(fontweight='bold')  # x מגדירים את התוויות על ציר
    plt.yticks(fontweight='bold')  # y מגדירים את התוויות על ציר          
    plt.xlabel('Number of complaints', fontweight='bold', fontsize=11) # x מוסיפים כותרת לציר
    plt.ylabel('Number of closed accounts', fontweight='bold', fontsize=11) # y מוסיפים כותרת לציר
    plt.title('Correlation between complaints and closed accounts (2023)', fontsize=14, 
              fontweight='bold') # מוסיפים כותרת לגרף
    plt.grid(True) #מציגים רשת על הגרף
    plt.tight_layout() # מארגנים שהתוויות לא יחתכו
    plt.show() # מציגים את הגרף
corr_compl_close_acc()