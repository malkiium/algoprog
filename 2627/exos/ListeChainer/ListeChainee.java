public class ListeChainee {

  private Cellule tete;
  private Cellule queue;
  private Cellule courant;

  public ListeChainee() {
    this.tete = null;
    this.queue = null;
    this.courant = null;
  }

  public ListeChainee(Cellule tete) {
    this.tete = tete;
    this.courant = tete;
    this.queue = tete;
    
    if (tete != null) {
      while (this.queue.getSuivant() != null) {
        this.queue = this.queue.getSuivant();
      }
    }
  }


  public boolean estVide() {
    return this.tete == null;
  }

  public Cellule getTete() {
    return this.tete;
  }

  public Cellule getQueue() {
    return this.queue;
  }

  public Cellule getCourant() {
    return this.courant;
  }

  public void razCourant() {
    this.courant = this.tete;
  }

  public void suivant() {
    if (this.courant != null) {
      this.courant = this.courant.getSuivant();
    }
  }

  public Object enTete() {
    if (this.tete == null) {
      return null;
    }
    return this.tete.getContenu();
  }

  public Object enCourant() {
    if (this.courant == null) {
      return null;
    }
    return this.courant.getContenu();
  }

  public void ajouteTete(Object o_tete) {
    Cellule t = new Cellule(o_tete);
    if (this.tete == null) {
      this.tete = t;
    } else {
      t.setSuivant(this.tete);
      this.tete = t;
    }
    if (this.queue == null) {
      this.queue = t;
    }
  }

  public void retireTete() {
    if (this.tete == null) {
      return;
    }
    this.tete = this.tete.getSuivant();
    
    if (this.tete == null) {
      this.queue = null;
    }
    this.razCourant();
  }

  public String toString() {
    String resultat = "";
    Cellule t = this.tete;

    while (t != null) {
      resultat += t.toString() + " ";
      t = t.getSuivant();
    } 
    return resultat;
  }
  
  public void ajouteQueue(Object o_queue) {
    Cellule t = new Cellule(o_queue);
  
    if (this.queue == null) {
      this.tete = t;
    } else {
      this.queue.setSuivant(t);
    }
    this.queue = t;
  }

  public void retireQueue() {
    this.razCourant();

    if (this.courant == null) {
      return;
    }
    if (this.courant.getSuivant() == null) {
      this.tete = null;
      this.queue = null;
    } else {
      while (this.courant.getSuivant().getSuivant() != null) {
        this.courant = this.courant.getSuivant();
      }
      this.courant.setSuivant(null);
      this.queue = this.courant;
    }
  }

  public void insereCourant(Object o) {

  }

}
