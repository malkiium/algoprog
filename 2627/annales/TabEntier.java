public class TabEntier {
  public int taille;
  public int[] elements;
  public TabEntier(int n) {
    this.taille = n;
    this.elements = new int[n];
  }
  public void triMin() {
    for (int i = taille-1; i>0; i--) {
      int min = i;
      int temp = 0;
      for (int j=i-1; j>=0; j--) {
        if (elements[min]>elements[j]) {
          min = j;
        }
      }
      temp = elements[min];
      elements[min] = elements[i];
      elements[i] = temp;
    }
  }
}
