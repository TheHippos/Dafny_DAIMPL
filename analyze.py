import pandas as pd
import pingouin as pg

def generate_publication_ready_tables(filepath):
    """
    Loads data, performs robust ANOVA, and generates a comprehensive
    set of publication-ready LaTeX tables, including a detailed
    performance breakdown by workload in the format Mean ± SD.

    Args:
        filepath (str): The path to the CSV data file.
    """
    try:
        df = pd.read_csv(filepath)
        print(f"Data loaded successfully from '{filepath}'.")
    except FileNotFoundError:
        print(f"Error: The file '{filepath}' was not found.")
        return

    # Use a space for cleaner group names in the pivot table header
    df['group'] = df['Language'] + ' ' + df['Variant']

    print("Performing analysis and generating final LaTeX tables...")

    # --- 1. Create the detailed performance comparison table (MODIFIED SECTION) ---

    # Assuming a single workload value is used for the entire dataset.
    # This value will be moved from the table body to the caption.
    try:
        workload_value = df['Workload'].unique()[0]
        workload_caption_str = f" for a workload of {workload_value:,} runs"
    except IndexError:
        workload_caption_str = "" # Handle case of empty DataFrame

    # Pivot the data to get both mean and standard deviation for performance
    performance_agg = df.pivot_table(
        index='Workload',
        columns=['Language', 'Variant'],
        values='Performance',
        aggfunc=['mean', 'std']
    ).round(0).astype(int)

    # Create a new DataFrame to hold the formatted "Mean ± SD" strings
    mean_df = performance_agg['mean']
    std_df = performance_agg['std']

    # Combine mean and std into the desired string format
    formatted_pivot = pd.DataFrame(index=mean_df.index, columns=mean_df.columns)
    for col in mean_df.columns:
        # The string format requires LaTeX's math mode for the \pm symbol
        formatted_pivot[col] = mean_df[col].astype(str) + ' $\\pm$ ' + std_df[col].astype(str)

    # Remove the workload from the table body by resetting the index
    formatted_pivot.reset_index(drop=True, inplace=True)

    # Reorder columns to match the desired layout: C#, Go, Python, Java
    formatted_pivot = formatted_pivot.reindex(columns=['csharp', 'go', 'python', 'java'], level=0)
    # Ensure handwritten is always before dafny
    formatted_pivot = formatted_pivot.reindex(columns=['handwritten', 'dafny'], level=1)


    # --- 2. Run Welch's ANOVA and Games-Howell Test ---
    welch_test = pg.welch_anova(data=df, dv='Performance', between='group')
    games_howell_test = pg.pairwise_gameshowell(data=df, dv='Performance', between='group')

    # --- 3. Filter for Key Comparisons ---
    filtered_comparisons = []
    for lang in df['Language'].unique():
        handwritten_group = f'{lang} handwritten'
        dafny_group = f'{lang} dafny'
        comparison = games_howell_test[
            ((games_howell_test['A'] == handwritten_group) & (games_howell_test['B'] == dafny_group)) |
            ((games_howell_test['A'] == dafny_group) & (games_howell_test['B'] == handwritten_group))
        ]
        if not comparison.empty:
            filtered_comparisons.append(comparison)
    filtered_df = pd.concat(filtered_comparisons)

    # --- 4. Save all LaTeX tables to a file ---
    latex_filename = 'latex_tables.txt'
    try:
        with open(latex_filename, 'w') as f:
            f.write("% LaTeX code generated from Python analysis script\n")
            f.write("% You may need the `booktabs`, `multirow`, and `siunitx` packages.\n\n\n")

            # --- LaTeX Table 1: Detailed Performance Comparison (MODIFIED) ---
            f.write("% --- Table 1: Detailed Performance Comparison ---\n")
            caption_text = f"Performance Comparison (Mean $\\pm$ SD) in ms{workload_caption_str}."

            detailed_table_latex = formatted_pivot.to_latex(
                caption=caption_text,
                label="tab:perf_data",
                multicolumn_format='c', # Center headers
                index=False,             # Don't print the DataFrame index
                escape=False             # Allow LaTeX commands like \pm and \$
            )
            # Manually modify for two-column format and better spacing
            detailed_table_latex = detailed_table_latex.replace('\\begin{table}', '\\begin{table*}[ht]', 1)
            detailed_table_latex = detailed_table_latex.replace('\\end{table}', '\\end{table*}', 1)
            f.write(detailed_table_latex)
            f.write("\n\n")

            # --- LaTeX Table 2: Welch's ANOVA Results ---
            f.write("% --- Table 2: Welch's ANOVA Results ---\n")
            welch_latex_df = welch_test.rename(columns={'ddof1': 'df1', 'ddof2': 'df2', 'p-unc': 'p-value', 'np2': '$\\eta_p^2$'})
            f.write(welch_latex_df.to_latex(
                index=False, float_format="%.4f",
                caption="Welch's ANOVA for Overall Group Differences on Performance.",
                label="tab:welch_anova", position="!htbp", escape=False
            ))
            f.write("\n\n")

            # --- LaTeX Table 3: Filtered Post-Hoc Results ---
            filtered_latex_df = filtered_df[['A', 'B', 'diff', 'pval', 'hedges']].copy()
            filtered_latex_df.rename(columns={
                'A': 'Group 1', 'B': 'Group 2', 'diff': 'Mean Diff.', 'pval': 'p-value', 'hedges': "Hedges' g"
            }, inplace=True)
            f.write("% --- Table 3: Key Post-Hoc Comparisons ---\n")
            key_comparison_latex = filtered_latex_df.to_latex(
                index=False, float_format="%.4f",
                caption="Games-Howell Post-Hoc Test Results for Dafny vs. Handwritten Variants.",
                label="tab:key_comparisons", position="!htbp"
            )
            key_comparison_latex = key_comparison_latex.replace('\\begin{table}', '\\begin{table*}', 1)
            key_comparison_latex = key_comparison_latex.replace('\\end{table}', '\\end{table*}', 1)
            f.write(key_comparison_latex)
            f.write("\n\n")

            # --- LaTeX Table 4: Full Post-Hoc Results for Appendix ---
            f.write("% --- Table 4: Full Post-Hoc Test Results (for Appendix) ---\n")
            full_comparison_latex = games_howell_test.to_latex(
                index=False, float_format="%.4f",
                caption="Full Pairwise Games-Howell Post-Hoc Test Results.",
                label="tab:full_comparisons", position="!htbp"
            )
            full_comparison_latex = full_comparison_latex.replace('\\begin{table}', '\\begin{table*}', 1)
            full_comparison_latex = full_comparison_latex.replace('\\end{table}', '\\end{table*}', 1)
            insert_pos = full_comparison_latex.find('\\label{tab:full_comparisons}') + len('\\label{tab:full_comparisons}')
            full_comparison_latex = full_comparison_latex[:insert_pos] + '\n\\small' + full_comparison_latex[insert_pos:]
            f.write(full_comparison_latex)

        print(f"All publication-ready LaTeX tables have been saved to '{latex_filename}'")

    except Exception as e:
        print(f"An error occurred while saving the LaTeX file: {e}")


if __name__ == '__main__':
    # Make sure you have a CSV file named 'only100kruns.csv' in the same directory
    # or provide the correct path to your file.
    # The CSV should have columns: 'Language', 'Variant', 'Workload', 'Performance'
    csv_file = 'only100kruns.csv'
    generate_publication_ready_tables(csv_file)
