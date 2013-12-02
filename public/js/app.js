App = Ember.Application.create({rootElement: '#app'});

//////// Routes

App.Router = Ember.Router.extend({
  location: 'none'
});

App.Router.map(function() {
  this.resource('companies')
  this.resource('company', { path: '/company/:company_id' }, function() {
    this.route('persons');
  });
});

App.IndexRoute = Ember.Route.extend({
  redirect: function() {
    this.transitionTo('companies');
  }
});

App.ApplicationRoute = Ember.Route.extend({
  actions: {
    openModal: function(modalName, model) {
      this.controllerFor(modalName).set('model', model);
      return this.render(modalName, {
        into: 'application',
        outlet: 'modal'
      });
    },

    closeModal: function() {
      return this.disconnectOutlet({
        outlet: 'modal',
        parentView: 'application'
      });
    }
  }
});

//////// Companies

App.CompaniesRoute = Ember.Route.extend({
  model: function() {
    return Ember.$.getJSON('/companies').then(function(data) {
      return data.companies;
    })
  },
  actions: {
    showPersonsPanel: function(company_id) {
      this.controllerFor('persons').set('company_id', company_id);
      return this.render('persons', {
        into: 'companies',
        outlet: 'persons'
      });
    },
    hidePersonsPanel: function() {
      return this.disconnectOutlet({
        outlet: 'persons',
        parentView: 'companies'
      });
    }
  }
});

App.CompaniesController = Ember.ArrayController.extend({
  actions: {
    createCompany: function () {
      var self = this;

      var payload = this.getProperties('name', 'country', 'city', 'address', 'email', 'phone')
      Ember.$.post('/companies', payload).then(function(data) {
        if (data.success) {
          self.pushObject(data.company);

          $('#new-company-dialog').modal('hide');

          self.set('name', '');
          self.set('country', '');
          self.set('city', '');
          self.set('address', '');
          self.set('email', '');
          self.set('phone', '');
        } else {
          alert(data.message);
        }
      })
    },
    updateSelectedRow: function(row) {
      var lastSelected = this.get('selectedRow');
      if (lastSelected) {
        lastSelected.set('selected', false);
      }

      row.set('selected', true);
      this.set('selectedRow', row);
    }
  }
})

App.CompanyController = Ember.ObjectController.extend({
  actions: {
    editCompany: function () {
      var copyModel = Ember.Object.create(this.getProperties('id', 'name', 'country', 'city', 'address', 'email', 'phone'));
      copyModel.set('originalController', this);
      this.send("openModal", "edit-company", copyModel);
    },
    acceptChanges: function () {
      this.get('model').save();
    },
    destroyCompany: function () {
      var company = this.get('model');
      var self = this;
      Ember.$.post('/companies/' + company.id, {_method: 'delete'}).then(function(data) {
        if (data.success) {
          self.target.parentController.removeObject(company)
        } else {
          alert(data.message);
        }
      })
    },
    editPersons: function() {
      var company = this.get('model');
      this.send('updateSelectedRow', this);
      this.transitionToRoute('company.persons', company);
    }
  }
});

App.EditCompanyController = Ember.ObjectController.extend({
  actions: {
    update: function(callback) {
      var company = this.get('model');
      var self = this;

      var payload = this.getProperties('name', 'country', 'city', 'address', 'email', 'phone');
      payload['_method'] = 'put';
      Ember.$.post('/companies/' + company.id, payload).then(function(data) {
        if (data.success) {
          var control = company.get('originalController');
          control.setProperties(data.company);

          callback();
        } else {
          alert(data.message);
        }
      })

    }
  }
});

App.EditCompanyView = Ember.View.extend({
  templateName: "edit-company",
  didInsertElement: function() {
    this.$('.modal').modal('show');
    this.$('.modal').one("hidden.bs.modal", this._dialogClose.bind(this));
    this.$('.modal .update').click(this._updateClicked.bind(this));
  },
  _dialogClose: function() {
    if (!this.isDestroyed) {
      this.destroy();
    }
    return this.send('closeModal');
  },
  _updateClicked: function() {
    var self = this;
    this.get('controller').send('update', function() {
      self.$('.modal').modal('hide');
      self.send('closeModal');
    });
  }
})

//////// Persons

App.CompanyPersonsRoute = Ember.Route.extend({
  model: function(params) {
    this.set('company_id', params.company_id);
    return Ember.$.getJSON('/persons?company_id=' + params.company_id).then(function(data) {
      return data.persons;
    })
  },
  renderTemplate: function(company_id) {
    return this.render('persons', {
      into: 'companies',
      outlet: 'persons'
    });
  }
});


App.CompanyPersonsController = Ember.ArrayController.extend({
  actions: {
    createPerson: function () {
      var self = this;

      var payload = {name: this.get('newName'), company_id: this.company_id}
      Ember.$.post('/persons', payload).then(function(data) {
        if (data.success) {
          self.pushObject(data.person);

          self.set('newName', '');
        } else {
          alert(data.message);
        }
      })
    }
  }
})