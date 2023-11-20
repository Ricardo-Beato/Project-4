import pandas as pd

def cleaning_lego():
    """
    purpose of this function is to import the dataset, clean it a 
    little and in the end export the cleaned version as a csv 
    so it's ready to be used in MySQL workbench
    """
    lego_dataframe = pd.read_csv("../Data/LEGO sets.csv")

    # I want to focus my analysis on the price of the sets, even if I remove the NaN in the current_price column, 
    # I'm still left out with a substantial amount of values to work with:
    lego_dataframe.dropna(subset=["Current_Price"], inplace = True)

    #I'm really not that much interested in the USD_MSRP column, not only is it not specified in the datasource (what is this even?) 
    # but it is not 100% filled with values either. Let's drop it like it's hot:
    lego_dataframe.drop("USD_MSRP", axis = 1,inplace=True)

    lego_dataframe.to_csv('../Data/LEGO sets_cleaned.csv', index=False)

cleaning_lego()


