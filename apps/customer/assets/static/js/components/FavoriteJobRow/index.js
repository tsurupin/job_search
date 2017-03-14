import React, { PropTypes, Component } from 'react';
import { Link } from 'react-router';
import { SelectField } from 'components';

const propTypes = {
  jobId: PropTypes.number.isRequired,
  jobTitle: PropTypes.string.isRequired,
  area: PropTypes.string.isRequired,
  status: PropTypes.number,
  company: PropTypes.string.isRequired,
  remarks: PropTypes.string,
  index: PropTypes.number.isRequired,
  handleRemove: PropTypes.func.isRequired,
  handleUpdate: PropTypes.func.isRequired
};

const statusOptions = {"interesting": 0, "applying": 1};
const interestOptions = {"interesting": 0, "very interesting": 2, "my dream": 3}

class FavoriteJobRow extends Component {
  constructor(props) {
    super(props);
    const { interest, remarks, status } = props;

    this.state = {
      interest,
      remarks,
      status: status || 0,
      canSubmit: false
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleSubmit(e) {
    e.preventDefault();
    this.props.handleUpdate(this.props.jobId, this.props.sortRank, this.getUpdatedAttributes())
  }

  handleRemove() {
    this.props.handleRemove(this.props.jobId, this.props.sortRank);
  }

  handleChange(key, value) {
    let updatedAttribute = {};
    updatedAttribute[key] = value;
    updatedAttribute['canSubmit'] = true;
    this.setState(updatedAttribute);
  }

  canSubmit() {
    return this.state.canSubmit && !this.props.submitting
  }

  getUpdatedAttributes() {
    let attributes = {};
    if (this.props.interest !== this.state.interest) { attributes["interest"] = this.state.interest }
    if (this.props.status !== this.state.status) { attributes["status"] = this.state.status }
    if (this.props.remarks !== this.state.remarks) { attributes["remarks"] = this.state.remarks }
    return attributes;
  }

  labelId(name) {
    return `${name}_${this.props.jobId}`
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div>
          <h3>{this.props.jobTitle}</h3>
          <p>{this.props.company}</p>
          <p>{this.props.area}</p>
        </div>
        <SelectField
          name="interest"
          tabIndex={2}
          value={parseInt(this.state.interest)}
          options={interestOptions}
          handleChange={this.handleChange}
        />
        <SelectField
          name="status"
          tabIndex={3}
          value={parseInt(this.state.status)}
          options={statusOptions}
          handleChange={this.handleChange}
        />
        <div className="form-control">
          <label htmlFor={this.labelId("remarks")} className="label">Remakrs</label>
          <textarea
            id={this.labelId("remarks")}
            name="remarks"
            defaultValue={this.props.remarks}
            rows={3}
            onBlur={(e) => this.handleChange(e.target.name, e.target.value)}
          />
        </div>
        <div className="actionBox">
          <input
            type="submit"
            disabled={!this.canSubmit()}
            tabIndex={4}
            value="Update"
          />
          <button type="button" onClick={this.handleRemove}>UnFavorite</button>
        </div>
      </form>
    )
  }
}

FavoriteJobRow.propTypes = propTypes;
export default FavoriteJobRow;